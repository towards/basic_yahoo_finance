# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0] - 2026-02-21

### Added

- Historical data query method (`history`) with support for single/multiple stocks and custom intervals by [@lucienLopez](https://github.com/lucienLopez)
- Include minitest and minitest-mock gems required by newer Ruby 3.4.x versions

### Changed

- Update gem dependencies and Ruby version

### Fixed

- Broken API query generating HTTP 404 Not Found error

### Removed

- Possibility to use modules in query

## [0.5.2] - 2025-03-29

### Changed

- Update gem dependencies and Ruby version

## [0.5.1] - 2023-07-14

### Changed

- Revert back to v6 endpoint of API by [@daviddigital](https://github.com/daviddigital)

## [0.5.0] - 2023-05-29

### Added

- Possibility to query multiple stocks at the same time

### Changed

- Implement persistent HTTP by [@daviddigital](https://github.com/daviddigital)
- generate_currency_symbols() return an array instead of a string
- Default to "price" module if nothing specificed in quotes()
- Update to use v10 version endpoint of API by [@daviddigital](https://github.com/daviddigital)

### Fixed

- MiniTest tests for full 100% code coverage

## [0.4.0] - 2023-05-23

### Added

- SimpleCov coverage badge
- Tests for failing quotes method due to HTTPError
- Test for quotes method raising OpenURI::HTTPError
- SimpleCov for code coverage

### Changed

- Update gem dependencies and Ruby version

### Fixed

- Workaround for broken API URL generating HTTP 403 Forbidden error

## [0.3.1] - 2023-02-12

### Changed

- Comment out not yet implemented use of redis dependency by [@svoop](https://github.com/svoop)
- Update gem dependencies and Ruby version

## [0.3.0] - 2022-05-06

### Added

- Initial setup for redis caching
- Utility class with symbols generator used in currency queries
- Foreign exchange symbol generator and finder
- Rubygems MFA requirement

### Changed

- Fix format of returned symbol for FX symbol finder
- Update gems
- Parse URI before opening request to API

## [0.2.0] - 2021-02-05

### Changed

- User-Agent header in API requests to announce as "BYF" instead of default "Ruby"
- Invalid ticker test to new behaviour of the API when the ticker does not exist

## [0.1.0] - 2021-01-29

### Added

- Initial release
