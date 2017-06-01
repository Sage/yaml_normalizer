# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added

### Changed

### Removed


## [0.2.1] - 2017-06-01
### Added
- CHANGELOG.md

### Changed
- Fix handling of UTF-8-encoded files using byte order mark


## [0.2.0] - 2017-05-10
### Added
- Add file configuration to rake task
- Add YAML check service, including rake task
- Add ci_task helper methods
- Add more documentation and improve wording

### Changed
- Enable RSpec's verify_partial_doubles and disable_monkey_patching
- Change License to Apache-2.0
- Move CI helper methods to separate file
- Make printed file paths relative
- Disable output while running specs
- Update section Usage in README
- Make "rake ci" the default rake task

### Removed
- Remove flay
- Remove cane
- Remove Ruby refinements


## [0.1.0] - 2017-04-07
### Added
- Minimal initial version of "YAML Normalizer", fmi see README.md
