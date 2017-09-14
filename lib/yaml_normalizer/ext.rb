# frozen_string_literal: true

module YamlNormalizer
  # Ext holds extensions to external dependencies
  # YamlNormalizer does not extend Ruby Core classes to avoid side effects
  module Ext
  end
end

require 'yaml_normalizer/ext/namespaced'
require 'yaml_normalizer/ext/nested'
require 'yaml_normalizer/ext/sort_by_key'
