# frozen_string_literal: true

require 'optparse'

module YamlNormalizer
  module Helpers
    # Methods handling passing of additional params from CLI
    module ParamParser
      # rubocop:disable Metrics/MethodLength

      # Parse the params provided to the service
      # @param [Array] args - params passed to the service
      # @return nil
      def parse_params(*args)
        OptionParser.new do |opts|
          opts.banner = "Usage: #{program_name} [options] file1, file2..."
          opts.on('-v', '--version', 'Prints the yaml_normalizer version') do
            print_version
            exit_success
          end
          opts.on('-h', '--help', 'Prints this help') do
            print(opts)
            exit_success
          end
        end.parse(args)
      end
      # rubocop:enable Metrics/MethodLength

      # Print current version of the tool
      def print_version
        print("#{YamlNormalizer::VERSION}\n")
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
