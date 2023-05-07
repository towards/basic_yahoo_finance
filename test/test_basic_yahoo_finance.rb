# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "minitest/autorun"
require "minitest/emoji"
require "basic_yahoo_finance"

class BasicYahooFinanceTest < Minitest::Test
  def setup
    @query = BasicYahooFinance::Query.new
  end

  def test_valid_ticker
    assert_includes(@query.quotes("AVUV"), "AVUV")
  end

  def test_multiple_tickers
    quotes = @query.quotes(%w[AVDV AVEM])
    assert_includes(quotes, "AVDV")
    assert_includes(quotes, "AVEM")
  end

  def test_invalid_ticker
    assert_empty @query.quotes("ZZZZ")
  end

  def test_quotes_httperror
    raises_exception = ->(_symbols) { raise OpenURI::HTTPError.new("message", "io") }
    @query.stub :quotes, raises_exception do
      assert_raises(OpenURI::HTTPError) { @query.quotes("ZZZZ") }
    end
  end

  def test_find_fx_symbol_gbp_chf
    assert_equal "GBPCHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("GBP/CHF"), "GBP", "CHF")
  end

  def test_find_fx_symbol_usd_chf
    assert_equal "CHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("USD/CHF"), "USD", "CHF")
  end

  def test_generate_currency_symbols
    assert_equal "USDCHF=X,EURCHF=X", BasicYahooFinance::Util.generate_currency_symbols(%w[USD EUR], "CHF")
  end

  def test_generate_fx_symbol_gbp_chf
    assert_equal "GBP/CHF", BasicYahooFinance::Util.generate_fx_symbol("GBP", "CHF")
  end

  def test_generate_fx_symbol_usd_chf
    assert_equal "CHF=X", BasicYahooFinance::Util.generate_fx_symbol("USD", "CHF")
  end
end
