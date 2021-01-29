# BasicYahooFinance

[![Gem Version](https://badge.fury.io/rb/basic_yahoo_finance.svg)](https://badge.fury.io/rb/basic_yahoo_finance)

This is a simple Ruby gem to query the Yahoo! Finance API.

Most of the available gems available on rubygems.org for this purpose are either not maintained anymore or simply do not working due to outdated API code. The goal of this gem is to be as basic as possible, hence the name, and to "simply" work. It would be typcially used to get information such as ask/bid price, close price, volume, for one or more stocks by using its symbol. The data is returned raw directly from the API as JSON output.

Lastly, this gem also has the advantage of having no dependencies to any other third-party gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'basic_yahoo_finance'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install basic_yahoo_finance

## Usage

Instantiate the `Query` class and use the quotes method on it with either one single symbol as `String` or by passing an `Array` of symbols such as show in the two examples below.

```ruby
# Query one single stock

query = BasicYahooFinance::Query.new
data = query.quotes('AVEM')

# Query multiple stocks

query = BasicYahooFinance::Query.new
data = query.quotes(['AVDV', 'AVUV'])
```

This will return a `Hash` of hashes with each stock information available under its symbol name as key in the `Hash`. For example:

```ruby
# Get stock's actual price

data['AVEM']['regularMarketPrice']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

MiniTest is used as test framework and can be run using:

    $ rake test

As linter RuboCop is used and can be run using:

    $ rake rubocop

This gem has been developed with Ruby 3.0 but should be downward compatible with at least all supported versions of Ruby.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/towards/basic_yahoo_finance. If you submit a pull request please make sure to write a test case covering your changes.
