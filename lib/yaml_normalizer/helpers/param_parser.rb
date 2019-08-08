# frozen_string_literal: true

require 'optparse'

module YamlNormalizer
  module Helpers
    # Methods handling passing of additional params from CLI
    module ParamParser
      # Parse the params provided to the service
      # @param [Array] args - params passed to the service
      # @return nil
      def parse_params(*args)
        OptionParser.new do |opts|
          opts.banner = "Usage: #{program_name} [options] file1, file2..."
          opts.on('-v', '--version', 'Prints the yaml_normalizer version') { print_version }
          opts.on('-h', '--help', 'Prints this help') { print_help(opts) }
        end.parse(args)
      end

      # Print current version of the tool
      def print_version
        print("#{YamlNormalizer::VERSION}\n")
        exit_success
      end

      # Print current version of the tool
      def print_help(opts)
        print(opts)
        exit_success
      end

      private

      def program_name
        $PROGRAM_NAME.split('/').last
      end

      def exit_success
        exit unless ENV['ENV'] == 'test'
      end
    end
  end
end
