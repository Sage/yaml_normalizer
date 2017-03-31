# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stable_yaml_formatter/version'

# rubocop:disable Metrics/BlockLength
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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'psych', '~> 2.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'flay'
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
end
