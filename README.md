# Yaml Normalizer

[![Build Status](https://travis-ci.org/Sage/yaml_normalizer.svg?branch=master)](https://travis-ci.org/Sage/yaml_normalizer)
[![Maintainability](https://api.codeclimate.com/v1/badges/8dccb6c06fcd8bc0e587/maintainability)](https://codeclimate.com/github/Sage/yaml_normalizer/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8dccb6c06fcd8bc0e587/test_coverage)](https://codeclimate.com/github/Sage/yaml_normalizer/test_coverage)

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
    $ git clone git@github.com:Sage/yaml_normalizer.git
    $ cd yaml_normalizer
    $ gem build yaml_normalizer.gemspec
    $ gem install yaml_normalizer*.gem

## Usage
### Use binary
After installing Yaml Normalizer, run `yaml_normalizer` from console:

    $ yaml_normalizer my_yaml_file.yml

### Include Yaml Normalizer rake tasks
In your Gemfile, add

      gem 'yaml_normalizer', git: 'git@github.com:Sage/yaml_normalizer.git', tag: 'v0.2.2', require: false
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

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

##### Set up yaml_normalizer
    $ git clone git@github.com:Sage/yaml_normalizer.git
    $ cd yaml_normalizer/
    $ gem install bundler
    $ bundle install

##### Install from source locally
    $ bundle exec rake install:local

#### Generate Documentation
##### Using Yard
    $ bundle exec rake yard

#### Test Implementation
##### Run all CI tasks
    $ bundle exec rake

##### Run Guard
    $ bundle exec guard

##### Run RSpec
    $ bundle exec rake spec

##### Run parallel RSpec
    $ bundle exec parallel_rspec spec/

#### Test Tests using mutant
    $ bundle exec rake mutant

#### Test Documentation using Inch
    $ bundle exec rake inch

#### Check and Correct static code metrics using Rubocop
    $ bundle exec rake rubocop
    $ bundle exec rake rubocop:auto_correct

#### Run Flog (check complexity)
    $ bundle exec flog -a lib

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

Copyright (c) 2017 Sage Group Plc. All rights reserved.
