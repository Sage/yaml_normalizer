# frozen_string_literal: true

require 'pathname'

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
        hashes = parse(yaml).transform
        hashes.each { |hash| hash.extend(Ext::SortByKey) }
        hashes.map(&:sort_by_key).map(&:to_yaml).join
      end

      private

      def parse(yaml)
        Psych.parse_stream(yaml)
      end

      def read(file)
        File.read(file, mode: 'r:bom|utf-8')
      end

      def relative_path_for(file)
        realpath = Pathname.new(file).realpath
        realpath.relative_path_from(Pathname.new(Dir.pwd))
      end
    end
  end
end
