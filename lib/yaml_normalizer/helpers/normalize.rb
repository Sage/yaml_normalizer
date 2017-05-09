# frozen_string_literal: true

module YamlNormalizer
  module Helpers
    # This helper holds shared functionality to normalize a YAML string.
    module Normalize
      # Transforms a given YAML string to a normalized format.
      # @example
      #   class YamlWriter
      #     include YamlNormalizer::Helpers::Normalize
      #
      #     def initialize(yaml)
      #       @yaml = normalize_yaml(yaml)
      #     end
      #
      #     def write(file)
      #       File.open(file,'w') { |f| f.write(@yaml) }
      #     end
      #   end
      # @param [String] valid YAML string
      # @return [String] normalized YAML string
      def normalize_yaml(yaml)
        hashes = Psych.parse_stream(yaml).transform
        hashes.each { |hash| hash.extend(Ext::SortByKey) }
        hashes.map(&:sort_by_key).map(&:to_yaml).join
      end
    end
  end
end
