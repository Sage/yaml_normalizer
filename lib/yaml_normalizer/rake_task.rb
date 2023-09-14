# frozen_string_literal: true

lib = File.expand_path(File.join('..', '..', '..', 'lib'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_normalizer'
require 'rake/tasklib'

module YamlNormalizer
  # Provides Rake task integration
  class RakeTask < ::Rake::TaskLib
    # The name of the rake task
    # @return [String] name of the rake task
    attr_accessor :name

    # The YAML files to process.
    # @example
    #   YamlNormalizer::RakeTask.new do |task|
    #     task.files = ['config/locale/*.yml', 'config/*.yml']
    #   end
    # @return [Array<String>] a list of file globing Strings
    attr_accessor :files

    # Add YAML Normalizer rake tasks to your project by adding the following line to your Rakefile:
    #   YamlNormalizer::RakeTask.new
    #
    # This gives you the following tasks (run rake -T)
    #   rake yaml:check      # Check if configured YAML files are normalized
    #   rake yaml:normalize  # Normalize configured YAML files
    #
    # @example Configure YAML Normalizer's rake task
    #   YamlNormalizer::RakeTask.new do |config|
    #     config.files = Dir[File.join(File.dirname(__FILE__), 'include.yml')]
    #   end
    #
    # @param name [String] name of the rake task
    # @param &block [Proc] optional, evaluated inside the task definition
    def initialize(name = 'yaml', &block)
      super()
      yield(self) if block

      desc 'Check if configured YAML files are normalized'
      task("#{name}:check") { abort(check_failed(name)) unless check }

      desc 'Normalize configured YAML files'
      task("#{name}:normalize") { normalize }
    end

    private

    # Error message to be printed if check fails
    def check_failed(name)
      "#{name}:check failed.\n" \
        "Run 'rake #{name}:normalize' to normalize YAML files.\n"
    end

    # Checks if configured YAML are normalized
    def check
      Services::Check.call(*files)
    end

    # Normalizes configured YAML files
    def normalize
      Services::Normalize.call(*files)
    end
  end
end
