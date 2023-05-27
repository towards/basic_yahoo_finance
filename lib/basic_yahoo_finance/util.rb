# frozen_string_literal: true

module BasicYahooFinance
  # Small useful utility methods
  class Util
    # Find correct FX symbol in quotes as the symbol format can vary
    def self.find_fx_symbol(quotes, currency1, currency2)
      # Exception for USDCHF=X symbol as it is sometimes returned as CHF=X
      if currency1 == "USD" && currency2 == "CHF"
        quotes["USDCHF=X"].nil? ? "CHF=X" : "#{currency1}CHF=X"
      else
        "#{currency1}#{currency2}=X"
      end
    end

    # Generate currency symbols based on array of currencies and base currency
    def self.generate_currency_symbols(currencies, base_currency)
      currency_symbols = []
      currencies.each do |currency|
        next if currency == base_currency

        currency_symbols.push("#{currency}#{base_currency}=X")
      end
      currency_symbols.join(",")
    end

    # Generate symobol for foreign exchange rate lookup
    def self.generate_fx_symbol(currency1, currency2)
      # Exception for USD against CHF which is formatted as 'CHF=X'
      if currency1 == "USD" && currency2 == "CHF"
        "#{currency2}=X"
      else
        "#{currency1}/#{currency2}"
      end
    end
  end
end
