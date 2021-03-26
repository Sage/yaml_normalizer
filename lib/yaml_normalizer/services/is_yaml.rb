# frozen_string_literal: true

require 'psych'

module YamlNormalizer
  module Services
    # IsYaml is a Service Class that provides functionality to check if a file
    # is a parseable non-scalar YAML file.
    # @exmaple
    #   is_yaml = YamlNormalizer::Services::IsYaml.new('path/to/file.yml')
    #   result = is_yaml.call
    class IsYaml < Base
      include Helpers::Normalize

      # file is the file path String to be regarded
      attr_reader :file

      # Create an IsYaml service object by calling .new and passing a file path
      # String.
      # @param file [String] file path to be regarded
      def initialize(file)
        @file = file.to_s
      end

      # Return true if given file is a valid YAML file
      def call
        file? && parseable? && !scalar?
      end

      private

      def file?
        File.file? file
      end

      # The current implementation does not require parseable? to return a
      # boolean value
      def parseable?
        parse(read(file))
      rescue Psych::SyntaxError => e
        $stderr.print "\t[ERROR] file is not parseable as YAML - #{e.message}\n\n"
        false
      end

      def scalar?
        Psych.load_file(file).instance_of? String
      end
    end
  end
end
