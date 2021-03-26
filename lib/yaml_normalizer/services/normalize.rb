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
      include Helpers::Normalize
      include Helpers::ParamParser

      # files is a sorted array of file path Strings
      attr_reader :files

      # Create a Normalize service object by calling .new and passing one or
      # more String that are interpreted as file glob pattern.
      # @param *args [Array<String>] a list of file glob patterns
      def initialize(*args)
        parse_params(*args)
        files = args.each_with_object([]) { |a, o| o << Dir[a.to_s] }
        @files = files.flatten.sort.uniq
      end

      # Normalizes all YAML files defined on instantiation.
      def call
        files.peach { |file| process(file) }
      end

      private

      def process(file)
        normalize!(file) if IsYaml.call(file)
      end

      def normalize!(file)
        $stdout.print "Processing #{file}\n"
        file = relative_path_for(file)

        if stable?(input = read(file), norm = normalize_yaml(input))
          File.open(file, 'w') { |f| f.write(norm) }
          $stdout.print "\t[PASSED] file has been normalized\n\n"
        else
          $stdout.print "\t[FAILED] file could not normalized\n\n"
        end
      end

      def stable?(yaml_a, yaml_b)
        convert(yaml_a).each_with_index.all? do |a, i|
          a.namespaced.eql?(convert(yaml_b).fetch(i).namespaced)
        end
      end

      def convert(yaml)
        ary = Psych.parse_stream(yaml).transform
        ary.each { |hash| hash.extend(Ext::Namespaced) }
        ary
      end
    end
  end
end
