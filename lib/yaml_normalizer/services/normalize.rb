# frozen_string_literal: true

require 'peach'

module YamlNormalizer
  module Services
    # Normalize is a Service that provides functionality to
    class Normalize < Base
      attr_reader :files

      using YamlNormalizer::Refinements::HashSortByKey
      using YamlNormalizer::Refinements::HashNamespaced

      def initialize(*args)
        files = args.each_with_object([]) { |a, o| o << Dir[a.to_s] }
        @files = files.flatten.sort.uniq
      end

      # Normalizes all YAML files defined on instantiation.
      def call
        files.peach do |file|
          if IsYaml.call(file)
            normalize!(file)
          else
            $stderr.puts "#{file} not a YAML file"
          end
        end
      end

      private

      def normalize!(file)
        if stable?(input = File.read(file), norm = normalize_yaml(input))
          File.open(file, 'w') { |f| f.write(norm) }
          $stderr.puts "[NORMALIZED] #{file}"
        else
          $stderr.puts "[ERROR]      Could not normalize #{file}"
        end
      end

      def normalize_yaml(yaml)
        hashes = Psych.parse_stream(yaml).transform
        hashes.map(&:sort_by_key).map(&:to_yaml).join
      end

      def stable?(yaml_a, yaml_b)
        parse(yaml_a).each_with_index.all? do |a, i|
          a.namespaced.eql?(parse(yaml_b).fetch(i).namespaced)
        end
      end

      def parse(yaml)
        Psych.parse_stream(yaml).transform
      end
    end
  end
end
