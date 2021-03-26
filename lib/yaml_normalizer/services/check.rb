# frozen_string_literal: true

require 'peach'

module YamlNormalizer
  module Services
    # Check is a service class that provides functionality to check if giving
    # YAML files are already standardized (normalized).
    # @exmaple
    #   check = YamlNormalizer::Services::Call.new('path/to/*.yml')
    #   result = check.call
    class Check < Base
      include Helpers::Normalize
      include Helpers::ParamParser

      # files is a sorted array of file path Strings
      attr_reader :files

      # Create a Check service object by calling .new and passing one or
      # more Strings that are interpreted as file glob pattern.
      # @param *args [Array<String>] a list of file glob patterns
      def initialize(*args)
        parse_params(*args)
        files = args.each_with_object([]) { |a, o| o << Dir[a.to_s] }
        @files = files.flatten.sort.uniq
      end

      # Normalizes all YAML files defined on instantiation.
      def call
        success = files.pmap { |file| process(file) }
        success.all?
      end

      private

      # process returns true on success and nil on error
      def process(file)
        $stdout.print "Processing #{file}\n"
        return true if IsYaml.call(file) && normalized?(file)

        nil
      end

      def normalized?(file)
        file = relative_path_for(file)
        input = read(file)
        norm = normalize_yaml(input)
        check = input.eql?(norm)

        if check
          $stdout.print "\t[PASSED] file is already normalized\n\n"
        else
          $stdout.print "\t[FAILED] file needs normalization\n\n"
        end

        check
      end
    end
  end
end
