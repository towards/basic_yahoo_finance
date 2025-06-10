# frozen_string_literal: true

require "json"
require "net/http/persistent"
require "net/http"

# require_relative "basic_yahoo_finance/cache"
require_relative "basic_yahoo_finance/util"
require_relative "basic_yahoo_finance/version"

module BasicYahooFinance
  # Class to send queries to Yahoo Finance API
  class Query
    API_URL = "https://query1.finance.yahoo.com"
    COOKIE_URL = "https://fc.yahoo.com"
    CRUMB_URL = "https://query1.finance.yahoo.com/v1/test/getcrumb"
    USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) " \
                 "Chrome/90.0.4421.0 Safari/537.36 Edg/90.0.810.1"

    def initialize(cache_url = nil)
      @cache_url = cache_url
      @cookie = fetch_cookie
      @crumb = fetch_crumb(@cookie)
    end

   def find_symbol_by_isin(isins_or_isin)
      hash_result = {}
      isins = make_symbols_array(isins_or_isin)

      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      isins.each do |isin|
        uri = URI("#{API_URL}/v1/finance/search?q=#{isin}&quotesCount=1&newsCount=0&listsCount=0&quotesQueryId=tss_match_phrase_query")
        response = http.request(uri)
        hash_result.store(isin, process_isin_output(JSON.parse(response.body)))
        sleep 0.1 # the sleep is needed to avoid request limit
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError => e
        hash_result.store(isin, "HTTP Error: #{response.body}, e.message: #{e.message}")
      end

      http.shutdown

      hash_result
    end

    def charts(symbol, mod: nil, range: "1d", interval: "1d", profile: nil) # rubocop:disable Metrics/MethodLength
      hash_result = {}
      symbols = make_symbols_array(symbol)
      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      symbols.each do |sym|
        query_params = []
        query_params << "interval=#{interval}" if interval
        query_params << "range=#{range}" if range
        query_params << "profile=#{profile}" if profile

        uri_string = "#{API_URL}/v8/finance/chart/#{sym}"
        uri_string += "?#{query_params.join("&")}" if query_params.any?

        uri = URI(uri_string)
        response = http.request(uri)
        hash_result.store(sym, process_chart_output(JSON.parse(response.body), mod))
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError
        hash_result.store(sym, "HTTP Error")
      end

      http.shutdown

      hash_result
    end

    def quotes(symbol) # rubocop:disable Metrics/MethodLength
      hash_result = {}
      symbols = make_symbols_array(symbol)
      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = USER_AGENT
      http.override_headers["Cookie"] = @cookie
      symbols.each do |sym|
        uri = URI("#{API_URL}/v7/finance/quote?symbols=#{sym}&crumb=#{@crumb}")
        response = http.request(uri)
        hash_result.store(sym, process_output(JSON.parse(response.body)))
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError
        hash_result.store(sym, "HTTP Error")
      end

      http.shutdown

      hash_result
    end

    private

    def fetch_cookie
      http = Net::HTTP.get_response(URI(COOKIE_URL), { "Keep-Session-Cookies" => "true" })
      cookies = http.get_fields("set-cookie")
      cookies[0].split(";")[0]
    end

    def fetch_crumb(cookie)
      http = Net::HTTP.get_response(URI(CRUMB_URL), { "User-Agent" => USER_AGENT, "Cookie" => cookie })
      http.read_body
    end

    def make_symbols_array(symbol)
      if symbol.instance_of?(Array)
        symbol
      else
        [symbol]
      end
    end

    def process_isin_output(json)
      json["quotes"]&.dig(0, "symbol")
    end

    def process_chart_output(json, mod)
      # Handle error from the API that the code isn't found
      if json["chart"] && json["chart"]["error"]
        json["chart"]["error"]
      else
        mod ? json["chart"]&.dig("result", 0, mod) : json["chart"]&.dig("result", 0)
      end
    end

    def process_output(json)
      # Handle error from the API that the code isn't found
      if json["error"]
        json["error"]
      else
        json["quoteResponse"]&.dig("result", 0)
      end
    end
  end
end
