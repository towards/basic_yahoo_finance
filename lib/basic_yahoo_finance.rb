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
    API_URL = "https://query2.finance.yahoo.com"

    def initialize(cache_url = nil)
      @cache_url = cache_url
    end

    def find_symbol_by_isin(isin)
      hash_result = {}
      isins = make_symbols_array(isin)

      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      isins.each do |isin|
        uri = URI("#{API_URL}/v1/finance/search?q=#{isin}&quotesCount=1&newsCount=0&listsCount=0&quotesQueryId=tss_match_phrase_query")
        response = http.request(uri)
        hash_result.store(isin, process_isin_output(JSON.parse(response.body)))
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError
        hash_result.store(sym, "HTTP Error")
      end

      http.shutdown

      hash_result
    end

    def chart(symbol, mod) # rubocop:disable Metrics/MethodLength
      hash_result = {}
      symbols = make_symbols_array(symbol)
      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      symbols.each do |sym|
        uri = URI("#{API_URL}/v8/finance/chart/#{sym}?interval=1d&range=1d")
        response = http.request(uri)
        hash_result.store(sym, process_output(JSON.parse(response.body), mod))
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError
        hash_result.store(sym, "HTTP Error")
      end

      http.shutdown

      hash_result
    end

    def quotes(symbol, mod = "price") # rubocop:disable Metrics/MethodLength
      hash_result = {}
      symbols = make_symbols_array(symbol)
      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      symbols.each do |sym|
        uri = URI("#{API_URL}/v6/finance/quoteSummary/#{sym}?modules=#{mod}")
        response = http.request(uri)
        hash_result.store(sym, process_chart_output(JSON.parse(response.body), mod))
      rescue Net::HTTPBadResponse, Net::HTTPNotFound, Net::HTTPError, Net::HTTPServerError, JSON::ParserError
        hash_result.store(sym, "HTTP Error")
      end

      http.shutdown

      hash_result
    end

    private

    def make_symbols_array(symbol)
      if symbol.instance_of?(Array)
        symbol
      else
        [symbol]
      end
    end

    def process_isin_output(json)
      result = json["quotes"]&.dig(0, 'symbol')
      return nil if result.nil?

      result
    end

    def process_chart_output(json, mod)
      # Handle error from the API that the code isn't found
      return json["chart"]["error"] if json["chart"] && json["chart"]["error"]

      result = json["chart"]&.dig("result", 0)
      return nil if result.nil?

      return result[mod] if mod

      result
    end

    def process_output(json, mod)
      # Handle error from the API that the code isn't found
      return json["quoteSummary"]["error"] if json["quoteSummary"] && json["quoteSummary"]["error"]

      result = json["quoteSummary"]&.dig("result", 0)
      return nil if result.nil?

      result[mod]
    end
  end
end
