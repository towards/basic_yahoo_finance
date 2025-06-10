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
    assert_includes(@query.quotes("AVUV"), "AVUV")
  end

  def test_invalid_ticker
    assert_nil(@query.quotes("ZZZZ")["ZZZZ"])
  end

  def test_valid_tickers
    q = @query.quotes(%w[AVUV AVEM])
    assert_includes(q, "AVUV") and assert_includes(q, "AVEM")
  end

  def test_quote_price
    assert_includes(@query.quotes("AVUV")["AVUV"], "regularMarketPrice")
  end

  def test_http_error
    http = Net::HTTP::Persistent.new
    def http.request(_)
      raise Net::HTTPBadResponse, "Bad response"
    end
    Net::HTTP::Persistent.stub :new, http do
      result = @query.quotes("AVUV")
      assert_equal({ "AVUV" => "HTTP Error" }, result)
    end
  end

  def test_find_fx_symbol_gbp_chf
    assert_equal "GBPCHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("GBPCHF=x"), "GBP", "CHF")
  end

  def test_find_fx_symbol_usd_chf
    assert_equal "CHF=X", BasicYahooFinance::Util.find_fx_symbol(@query.quotes("USDCHF=x"), "USD", "CHF")
  end

  def test_generate_currency_symbols
    assert_equal ["USDCHF=X", "EURCHF=X"], BasicYahooFinance::Util.generate_currency_symbols(%w[USD EUR], "CHF")
  end

  def test_generate_fx_symbol_gbp_chf
    assert_equal "GBP/CHF", BasicYahooFinance::Util.generate_fx_symbol("GBP", "CHF")
  end

  def test_generate_fx_symbol_usd_chf
    assert_equal "CHF=X", BasicYahooFinance::Util.generate_fx_symbol("USD", "CHF")
  end

  def test_find_symbol_by_isin
    result = @query.find_symbol_by_isin("US0378331005") # Apple Inc. ISIN
    assert_includes(result, "US0378331005")
    assert_equal "AAPL", result["US0378331005"]
  end

  def test_find_symbol_by_isin_invalid
    result = @query.find_symbol_by_isin("INVALID123")
    assert_includes(result, "INVALID123")
    assert_nil result["INVALID123"]
  end

  def test_charts_basic
    result = @query.charts("AAPL")
    assert_includes(result, "AAPL")
    assert result["AAPL"].is_a?(Hash)
  end

  def test_charts_with_parameters
    result = @query.charts("AAPL", range: "1mo", interval: "1d")
    assert_includes(result, "AAPL")
    assert result["AAPL"].is_a?(Hash)
  end

  def test_charts_with_mod
    result = @query.charts("AAPL", mod: "indicators")
    assert_includes(result, "AAPL")
    assert result["AAPL"].is_a?(Hash)
  end

  def test_charts_invalid_symbol
    result = @query.charts("INVALID123")
    assert_includes(result, "INVALID123")
    assert_equal({"code"=>"Not Found", "description"=>"No data found, symbol may be delisted"}, result["INVALID123"])
  end

  def test_multiple_symbols
    result = @query.quotes(["AAPL", "MSFT"])
    assert_includes(result, "AAPL")
    assert_includes(result, "MSFT")
  end

  def test_process_isin_output
    json = {
      "quotes" => [
        { "symbol" => "AAPL" }
      ]
    }
    result = @query.send(:process_isin_output, json)
    assert_equal "AAPL", result
  end

  def test_process_isin_output_empty
    json = { "quotes" => [] }
    result = @query.send(:process_isin_output, json)
    assert_nil result
  end

  def test_process_chart_output
    json = {
      "chart" => {
        "result" => [
          {
            "indicators" => { "quote" => [] }
          }
        ]
      }
    }
    result = @query.send(:process_chart_output, json, "indicators")
    assert result.is_a?(Hash)
  end

  def test_process_chart_output_error
    json = {
      "chart" => {
        "error" => { "code" => "Not Found" }
      }
    }
    result = @query.send(:process_chart_output, json, nil)
    assert_equal({ "code" => "Not Found" }, result)
  end
end
