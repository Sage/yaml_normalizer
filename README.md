# Yaml Normalizer

[![Build Status](https://github.com/Sage/yaml_normalizer/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/Sage/yaml_normalizer/actions/workflows/ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/8dccb6c06fcd8bc0e587/maintainability)](https://codeclimate.com/github/Sage/yaml_normalizer/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8dccb6c06fcd8bc0e587/test_coverage)](https://codeclimate.com/github/Sage/yaml_normalizer/test_coverage)
[![Gem Version](https://badge.fury.io/rb/yaml_normalizer.svg)](https://badge.fury.io/rb/yaml_normalizer)

YAML is a file format that's human-readable and very common among Ruby projects.
The [YAML standard](http://yaml.org/) is well-defined and supported by many
programming languages. Ruby's default YAML parser and emitter is
[Psych](https://github.com/ruby/psych#psych).

Yaml Normalizer follows the notion that there is a normalized YAML file
format. It re-formats YAML files in a way that the results closely match Psych's
output. Yaml Normalizer ensures that the original file and the resulting
file are identical regarding the resulting Hash from Psych (stable change). The
primary target of this project are i18n YAML files.

Yaml Normalizer provides
* **Alphabetic Ordering**
  * to improve (human-)readability and maintainability,
  * to avoid duplicate keys,
  * to minimize effort when resolving merge conflicts in YAML files
* **Limited Line Length**
  * to improve (human-)readability and maintainability
* **Non-breaking Changes only**
  * to ensure changes do not impact functional parts of the application.
    Yaml Normalizer considers changing the order of YAML file entries as
    non-breaking,
  * to build maximum trust in Yaml Normalizer and its generated YAML files,
  * to avoid the need of manual reviews.

Yaml Normalizer can be used in frameworks like Rails, Sinatra or Cuba, but
it runs stand-alone as well.

## Installation
    gem install yaml_normalizer

## Usage
### Use executable files
Yaml Normalizer provides you with two executables: `yaml_normalize` and `yaml_check`.
To check and normalize ´a_yaml_file.yml´, run:

    yaml_check a_yaml_file.yml
    yaml_normalize a_yaml_file.yml

Print the installed version of Yaml Normalizer:

    yaml_check --version

Print help messages for ´yaml_check´ and `yaml_normalize`:

    yaml_check --help
    yaml_normalize --help

### Include Yaml Normalizer rake tasks
In your Gemfile, add

      gem 'yaml_normalizer', require: false

In a Rails context, you might want to only add it to `:development` and `:test` groups.

In your Rakefile, add

    require 'yaml_normalizer/rake_task'
    YamlNormalizer::RakeTask.new do |config|
      yamls = Dir['**/*.yml']  # TODO: Select relevant YAML files in your project.
      config.files = yamls
    end

This will give you two additional rake task (`rake -T`)

    rake yaml:check      # Check if configured YAML files are normalized
    rake yaml:normalize  # Normalize configured YAML files

## Development
Start developing Yaml Normalizer by installing the following dependencies:
* [git](https://git-scm.com/downloads) (version control)
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (programming language)
* [RubyGems](https://rubygems.org/pages/download) (package manager for Ruby)
* [Bundler](http://bundler.io/) (dependency manager for RubyGems)

### Set up Yaml Normalizer
    git clone git@github.com:Sage/yaml_normalizer.git
    cd yaml_normalizer/
    bundle install

### List available rake tasks
    bundle exec rake -T
```
rake ci                       # Continuous integration test suite (DEFAULT)
rake flog                     # Analyze for code complexity in: lib
rake inch                     # Check documentation coverage
rake mutant                   # Mutation testing to check mutation coverage of current RSpec test suite
rake rubocop                  # Run RuboCop
rake rubocop:autocorrect      # Autocorrect RuboCop offenses (only when it's safe)
rake rubocop:autocorrect_all  # Autocorrect RuboCop offenses (safe and unsafe)
rake spec                     # Run RSpec code examples
rake yard                     # Generate YARD Documentation
```

### Generate documentation locally using Yard
    bundle exec rake yard
After generating yard documentation, open generated index.html located in `doc/` in your browser.

### Test documentation quality using Inch
    bundle exec rake inch
    inch list --all
This task applies static code analysis to measure documentation quality. Inch also suggests improvements.

### Run RSpec
    bundle exec rake spec
    rspec
[RSpec](https://rubygems.org/gems/rspec) is a testing framework for Ruby. Running this task executes all tests located in `spec/`.

### Check and Correct static code metrics using Rubocop
    bundle exec rake rubocop
    rubocop

    bundle exec rake rubocop:autocorrect
    rubocop -a

    bundle exec rake rubocop:autocorrect_all
    rubocop -A
[Rubocop](https://rubygems.org/gems/rubocop) is a static code analyzer that checks for code quality and style issues.

### Run Flog (check complexity)
    bundle exec rake flog
[Flog](https://rubygems.org/gems/flog) is a static code analyzer that checks for code complexity.

### Run Guard
    bundle exec guard
[Guard](https://rubygems.org/gems/guard) keeps track of file changes and automatically runs tests related to updated files.

### Run continuous integration test suite
    bundle exec rake
Running this task executes the following tasks: ´ci_spec´ ´inch´ ´ci_flog´ ´rubocop`

### Test Tests using mutant (requires mutant-license)
    bundle exec rake mutant

## Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/Sage/yaml_normalizer.

### Engineering Standards
We want to keep engineering standards high and use code reviews and test tools
to help with that. Yaml Normalizer is designed to have no side effects,
especially regarding Ruby Core and Standard Lib implementation. Also, we want to
keep simplecov, rubocop, flog, inch and mutant happy. We will add more details
on PRs if needed.

## License
Yaml Normalizer is available as open source under the terms of the
[Apache-2.0 licence](https://github.com/Sage/yaml_normalizer/blob/master/LICENSE).

Copyright (c) 2017-2019 Sage Group Plc. All rights reserved.
