# frozen_string_literal: true

require "json"
require "open-uri"
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

    def quotes(symbol, mod = "price")
      hash_result = {}
      symbols = make_symbols_array(symbol)
      symbols.each do |sym|
        url = URI.parse("#{API_URL}/v10/finance/quoteSummary/#{sym}?modules=#{mod}")
        uri = URI.open(url, "User-Agent" => "BYF/#{BasicYahooFinance::VERSION}")
        hash_result.store(sym, process_output(JSON.parse(uri.read), mod))
      rescue OpenURI::HTTPError => e
        hash_result.store(sym, JSON.parse(e.io.read)["quoteSummary"]["error"] || "Unknown error")
      end
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
      json["quoteSummary"]["result"][0][mod]
    end
  end
end
