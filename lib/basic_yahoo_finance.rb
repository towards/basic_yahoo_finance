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

    def quotes(symbol, mod = "price") # rubocop:disable Metrics/MethodLength
      hash_result = {}
      symbols = make_symbols_array(symbol)
      http = Net::HTTP::Persistent.new
      http.override_headers["User-Agent"] = "BYF/#{BasicYahooFinance::VERSION}"
      symbols.each do |sym|
        uri = URI("#{API_URL}/v6/finance/quoteSummary/#{sym}?modules=#{mod}")
        response = http.request(uri)
        hash_result.store(sym, process_output(JSON.parse(response.body), mod))
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

    def process_output(json, mod)
      # Handle error from the API that the code isn't found
      return json["quoteSummary"]["error"] if json["quoteSummary"] && json["quoteSummary"]["error"]

      result = json["quoteSummary"]&.dig("result", 0)
      return nil if result.nil?

      result[mod]
    end
  end
end