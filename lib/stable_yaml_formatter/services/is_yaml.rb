# frozen_string_literal: true

require 'psych'

module StableYamlFormatter
  module Services
    # describe!
    class IsYaml < Base
      attr_reader :file

      def initialize(file)
        @file = file.to_s
      end

      # Return true if given file is a valid YAML file
      def call
        file? && parsable? && !scalar?
      end

      private

      def file?
        File.file? file
      end

      # The current implementation does not require parsable? to return a
      # boolean value
      def parsable?
        Psych.load_file(file)
      rescue Psych::SyntaxError
        false
      end

      def scalar?
        Psych.load_file(file).instance_of? String
      end
    end
  end
end
