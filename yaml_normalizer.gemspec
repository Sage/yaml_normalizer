# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_normalizer/version'
# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'yaml_normalizer'
  spec.version       = YamlNormalizer::VERSION
  spec.authors       = ['Wolfgang Teuber']
  spec.email         = ['wolfgang.teuber@sage.com']

  spec.summary       = 'Yaml Normalizer normalizes YAML files'
  spec.description   = "Yaml Normalizer follows the notion that there is
    a normalized YAML file format. It re-formats YAML files in a way that the
    results closely match Psych's output. Yaml Normalizer ensures that the
    original file and the resulting file are 100% identical to Psych (stable
    change)."
  spec.homepage      = 'https://github.com/Sage/yaml_normalizer'
  spec.license       = 'Apache-2.0'
  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = 'yaml_normalizer'
  spec.require_paths = ['lib']

  spec.add_dependency 'psych', '~> 2.2'
  spec.add_dependency 'peach', '~> 0.5'
  spec.add_dependency 'rake', '~> 12.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'mutant-rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'flog'
  spec.add_development_dependency 'inch'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'github-markup'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry'
  # Ruby 2.4.0 isn't supported by the latest pry-doc today (2017-04-07)
  # spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-byebug'
end
