# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

### Changed

### Removed

## [2.0.0] - 2023-09-06

### Added

- Tests now run against Ruby 3.0, 3.1, and 3.2

### Changed

- Update minimum Ruby version to v3.0
- Relaxed version constraint on Rake
- Set minimum Psych version to v5

## [1.2.0] - 2019-08-08

### Added

- Versioning and help messages for CLI

### Changed

- Extended allowed line length to 120
- Change the mutant to only scan the latest commits

## [1.1.0] - 2019-05-21

### Added

- Add rubocop-performance gem

### Changed

- Update Ruby version to 2.5
- Reduce average code complexity threshold to 6.3
- Use thread safe output in peach blocks
- Only require `pathname` when used

## [1.0.1] - 2018-05-04

### Changed

- Specify executables in Gemspec

## [1.0.0] - 2018-05-04

### Added

- Add .ruby-version file to improve development experience
- Add gem version badge to README
- Add pry-doc
- Add helper method to retrieve relative path for a file
- Add executable "yaml_check" to check normalization of YAML files

### Changed

- Clean up README
- Rename executable to normalize YAML files to "yaml_normalize"
- Lower average complexity threshold to 6.5

### Removed

- Remove parallel_tests
- Remove console and setup executables
- Remove bundler/gem_tasks

## [0.3.0] - 2018-03-26

### Added

- Add YamlNormalizer::Ext::Nested to generate nested hash from namespaces key-value pairs
- Add Codeclimate integration https://codeclimate.com/github/Sage/yaml_normalizer/

### Changed

- Change flog method to :average, set threshold to 7.7
- Reset default_proc before returning to app code
- Open-source Yaml Normalizer at https://github.com/Sage/yaml_normalizer
- Changed travis setup to publish yaml_normalizer https://travis-ci.org/Sage/yaml_normalizer
- Publish Yaml Normalizer on https://rubygems.org/gems/yaml_normalizer
- Specify Ruby version "~> 2.4" in Gemfile
- Use warn instead of $stderr.puts
- Support sorting keys of different types

### Removed

- Remove Coveralls.io integration

## [0.2.2] - 2017-06-23

### Added

- Add hint to run normalize task when check task fails

### Changed

- Fix check rake task's exit value
- Fix return when checking YAMLs
- Fix section "rake -t" in README.md
- Fix mutant output parsing

### Removed

- Stop requiring simplecov when running mutation tests

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
