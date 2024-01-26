# frozen_string_literal: true

require_relative "lib/basic_yahoo_finance/version"

Gem::Specification.new do |spec|
  spec.name          = "basic_yahoo_finance"
  spec.version       = BasicYahooFinance::VERSION
  spec.authors       = ["Marc"]
  spec.email         = ["hello@towards.ch"]
  spec.licenses      = "GPL-3.0"
  spec.summary       = "Basic Yahoo Finance API to query stock prices"
  spec.description   = "Very simple Ruby API for Yahoo Finance in order to query the stock market"
  spec.homepage      = "https://towards.ch"
  spec.files         = Dir["lib/**/*", "CHANGELOG.md", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["bug_tracker_uri"] = "https://github.com/towards/basic_yahoo_finance/issues"
  spec.metadata["changelog_uri"] = "https://github.com/towards/basic_yahoo_finance/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/basic_yahoo_finance"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"] = "https://github.com/towards/basic_yahoo_finance"

  # spec.add_dependency "redis", "~> 5.0"
  spec.add_runtime_dependency "net-http-persistent", "~> 4.0", ">= 4.0.2"
end
