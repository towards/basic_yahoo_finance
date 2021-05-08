# frozen_string_literal: true

module BasicYahooFinance
  # Small useful utility methods
  class Util
    # Generate currency symbols based on array of currencies and base currency
    def self.generate_currency_symbols(currencies, base_currency)
      currency_symbols = []
      currencies.each do |currency|
        next if currency == base_currency

        currency_symbols.push("#{currency}#{base_currency}=X")
      end
      currency_symbols.join(",")
    end
  end
end
