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

    def history(symbol, period1, period2, interval = "1d")
      hash_result = {}
      symbols = make_symbols_array(symbol)

      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = USER_AGENT
      http.override_headers["Cookie"] = @cookie

      symbols.each do |sym|
        uri = URI("#{API_URL}/v8/finance/chart/#{sym}?period1=#{period1}&period2=#{period2}&interval=#{interval}&crumb=#{@crumb}")
        response = http.request(uri)
        hash_result.store(sym, process_history_output(JSON.parse(response.body)))
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

    def process_output(json)
      # Handle error from the API that the code isn't found
      return json["error"] unless json["error"].nil?

      result = json["quoteResponse"]&.dig("result", 0)
      return nil if result.nil?

      result
    end

    def process_history_output(json)
      # Handle error from the API that the code isn't found
      return json["error"] unless json["error"].nil?

      json
    end
  end
end
