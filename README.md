# Stable Yaml Formatter

YAML is a file format that's human-readable and very common among Ruby projects.
The [YAML standard](http://yaml.org/) is well-defined and supported by many
programming languages. Ruby's default YAML parser and emitter is
[Psych](https://github.com/ruby/psych#psych).

Stable Yaml Formatter follows the notion that there is a normalized YAML file
format. It re-formats YAML files in a way that the results closely match Psych's
output. Stable Yaml Formatter ensures that the original file and the resulting
file are 100% identical to Psych (stable change).

Stable Yaml Formatter provides
* **Alphabetic Ordering** (TODO)
  * to improve (human-)readability and maintainability
  * to avoid douplicate keys
* **Paragraphs** (TODO)
  * to improve (human-)readability and maintainability
* **Limited Line Length** (TODO)
  * to improve (human-)readability and maintainability
* **Update Verification** (TODO)
  * to ensure changes are actually "stable"

Stable Yaml Formatter can be used in frameworks like Rails, Sinatra or Cuba, but
it runs stand-alone as well.

## Installation
    $ gem install stable_yaml_formatter

## Usage
    $ stable_yaml_formatter my_yaml_file.yml

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

##### Install from source locally
    $ bundle exec rake install:local

#### Test Implementation
##### Run Guard (with Rspec and Rubocop)
    $ bundle exec guard

##### Run RSpec
    $ bundle exec rake spec

##### Run parallel RSpec
    $ bundle exec parallel_rspec spec/

##### Run Rubocop
    $ bundle exec rake rubocop
    $ bundle exec rake rubocop:auto_correct

#### Test Tests
##### Kill all mutants
    $ bundle exec rake mutant

#### Test Documentation
##### Using Yard
    $ bundle exec rake yard

##### Using Inch
    $ bundle exec rake inch

#### Test static code metrics
##### Run Cane (general code quality)
    $ bundle exec cane

##### Run Flay (duplication)
    $ bundle exec flay

##### Run Flog (complexity)
    $ bundle exec flog .

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sage/stable_yaml_formatter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
