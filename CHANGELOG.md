# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- Initial setup for redis caching
- Utility class with symbols generator used in currency queries
- Foreign exchange symbol generator and finder
- Rubygems MFA requirement

### Changed

- Fix format of returned symbol for FX symbol finder
- Update gems

## 0.2.0 - 2021-02-05

### Changed

- User-Agent header in API requests to announce as "BYF" instead of default "Ruby"
- Invalid ticker test to new behaviour of the API when the ticker does not exist

## 0.1.0 - 2021-01-29

### Added

- Initial release
