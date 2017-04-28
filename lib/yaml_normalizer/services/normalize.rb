# frozen_string_literal: true

require 'peach'

module YamlNormalizer
  module Services
    # Normalize is a service class that provides functionality to update giving
    # YAML files to a standardized (normalized) format.
    # @exmaple
    #   normalize = YamlNormalizer::Services::Normalize.new('path/to/*.yml')
    #   result = normalize.call
    class Normalize < Base
      # files is a sorted array of file path Strings
      attr_reader :files

      # Create a Normalize service object by calling .new and passing one or
      # more String that are interpreted as file glob pattern.
      # @param *args [Array] a list of file glob patterns
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
        hashes.each { |hash| hash.extend(Ext::SortByKey) }
        hashes.map(&:sort_by_key).map(&:to_yaml).join
      end

      def stable?(yaml_a, yaml_b)
        parse(yaml_a).each_with_index.all? do |a, i|
          a.namespaced.eql?(parse(yaml_b).fetch(i).namespaced)
        end
      end

      def parse(yaml)
        ary = Psych.parse_stream(yaml).transform
        ary.each { |hash| hash.extend(Ext::Namespaced) }
        ary
      end
    end
  end
end
