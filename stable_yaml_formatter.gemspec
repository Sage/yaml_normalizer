# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stable_yaml_formatter/version'
Gem::Specification.new do |spec|
  spec.name          = 'stable_yaml_formatter'
  spec.version       = StableYamlFormatter::VERSION
  spec.authors       = ['Wolfgang Teuber']
  spec.email         = ['wolfgang.teuber@sage.com']

  spec.summary       = 'Stable Yaml Formatter normalizes YAML files'
  spec.description   = "Stable Yaml Formatter follows the notion that there is
    a normalized YAML file format. It re-formats YAML files in a way that the
    results closely match Psych's output. Stable Yaml Formatter ensures that the
    original file and the resulting file are 100% identical to Psych (stable
    change)."
  spec.homepage      = 'https://github.com/Sage/stable_yaml_formatter'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = 'yaml_normalizer'
  spec.require_paths = ['lib']

  spec.add_dependency 'psych', '~> 2.2'
  spec.add_dependency 'pmap', '~> 1.1'

  [
    'bundler', 'rake', 'rspec', 'parallel_tests', 'mutant-rspec', 'rubocop',
    'cane', 'flay', 'flog', 'inch', 'coveralls', 'guard', 'guard-rubocop',
    'guard-rspec', 'yard', 'redcarpet', 'github-markup', 'awesome_print'
  ].each { |dep| spec.add_development_dependency(dep) }
end
