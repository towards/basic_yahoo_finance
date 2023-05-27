# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "simplecov-formatter-badge"
require "minitest/autorun"
require "minitest/emoji"
require "basic_yahoo_finance"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new \
  [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::BadgeFormatter]

class BasicYahooFinanceTest < Minitest::Test
  def setup
    @query = BasicYahooFinance::Query.new
  end

  def test_valid_ticker
    assert_includes(@query.quotes("AVUV", "price"), "AVUV")
  end

  def test_invalid_ticker
    assert_includes(@query.quotes("ZZZZ", "price"), "code")
  end

  def test_summary_detail_module
    assert_includes(@query.quotes("AVUV", "summaryDetail"), "AVUV")
  end

  def test_http_error
    error_message = @query.quotes("ZZZZ", "price")
    assert_includes(error_message, "code")
  end

  def test_find_fx_symbol_gbp_chf
    assert_equal "GBPCHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("GBPCHF=x", "price"), "GBP", "CHF")
  end

  def test_find_fx_symbol_usd_chf
    assert_equal "CHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("USDCHF=x", "price"), "USD", "CHF")
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
