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
    
    def quotes(symbol, mod)
      begin
        url = URI.parse("#{API_URL}/v10/finance/quoteSummary/#{symbol}?modules=#{mod}")
        uri = URI.open(url, "User-Agent" => "BYF/#{BasicYahooFinance::VERSION}")
        process_output(JSON.parse(uri.read), symbol, mod)
      
      rescue OpenURI::HTTPError => error
        error_message = JSON.parse(error.io.read)["quoteSummary"]["error"] || "Unknown error"
      end
    end

    private

    def process_output(json, symbol, mod)
      hash = {}
      module_data = json["quoteSummary"]["result"][0][mod]
      hash[symbol] = module_data

      hash
    end

  end
end
