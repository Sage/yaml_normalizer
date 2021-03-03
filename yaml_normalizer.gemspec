# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_normalizer/version'
Gem::Specification.new do |spec|
  spec.name          = 'yaml_normalizer'
  spec.version       = YamlNormalizer::VERSION
  spec.authors       = ['Wolfgang Teuber', 'Jan Taras']
  spec.email         = ['jan.taras@sage.com']

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
  spec.executables   = %w[yaml_check yaml_normalize]
  spec.require_paths = ['lib']

  spec.add_dependency 'peach', '~> 0.5'
  spec.add_dependency 'psych', '>= 2.2'
  spec.add_dependency 'rake', '~> 12.0'

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'flog'
  spec.add_development_dependency 'github-markup'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'inch'
  spec.add_development_dependency 'mutant-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'yard'
end
