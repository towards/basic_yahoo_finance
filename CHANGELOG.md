# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2023-05-23

### Added

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
