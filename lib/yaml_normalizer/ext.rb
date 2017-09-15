# frozen_string_literal: true

module YamlNormalizer
  # *YamlNormalizer::Ext* contains multiple extensions to extend instances of
  # *Hash* in several ways.
  # *YamlNormalizer* goes without extending Ruby Core classes or refinements
  # to provide no functionality without side effects and avoid unexpected
  # behaviour when working with POROs, fmi see https://git.io/v5Q2E.
  module Ext
  end
end

require 'yaml_normalizer/ext/namespaced'
require 'yaml_normalizer/ext/nested'
require 'yaml_normalizer/ext/sort_by_key'
