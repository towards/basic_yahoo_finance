# frozen_string_literal: true

require "json"
require "open-uri"
# require_relative "basic_yahoo_finance/cache"
require_relative "basic_yahoo_finance/util"
require_relative "basic_yahoo_finance/version"

module BasicYahooFinance
  # Class to send queries to Yahoo Finance API
  class Query
    API_URL = "https://query1.finance.yahoo.com"

    def initialize(cache_url = nil)
      @cache_url = cache_url
    end

    def quotes(symbols)
      symbols_value = generate_symbols_value(symbols)
      begin
        url = URI.parse("#{API_URL}/v6/finance/quote?symbols=#{symbols_value}")
        uri = URI.open(url, "User-Agent" => "BYF/#{BasicYahooFinance::VERSION}")
        process_output(JSON.parse(uri.read))
      rescue OpenURI::HTTPError
        empty_symbols_hash(symbols)
      end
    end

    private

    def generate_symbols_value(symbols, separator = ",")
      case symbols
      when String
        symbols
      when Array
        symbols.join(separator)
      end
    end

    def process_output(json)
      hash = {}
      if json["quoteResponse"]["result"].count == 1
        hash[json["quoteResponse"]["result"][0]["symbol"]] = json["quoteResponse"]["result"].pop
      elsif json["quoteResponse"]["result"].count > 1
        json["quoteResponse"]["result"].each do |r|
          hash[r["symbol"]] = r
        end
      end
      # TODO: compare hash keys with symbol(s) requested and add symbols which had no results from API
      hash
    end

    def empty_symbols_hash(symbols)
      hash = {}
      case symbols
      when String
        hash[symbols] = {}
      when Array
        symbols.each do |s|
          hash[s] = {}
        end
      end
      hash
    end
  end
end
