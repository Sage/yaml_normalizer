# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_normalizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'yaml_normalizer'
  spec.version       = YamlNormalizer::VERSION
  spec.authors       = ['The Sage Group plc']
  spec.email         = ['support@sageone.com']

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

  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'peach', '~> 0.5'
  spec.add_dependency 'psych', '~> 5.0'
  spec.add_dependency 'rake', '< 14.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
