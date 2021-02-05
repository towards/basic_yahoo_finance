# frozen_string_literal: true

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
end
