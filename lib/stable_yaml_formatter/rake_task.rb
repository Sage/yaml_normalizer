# frozen_string_literal: true

require 'stable_yaml_formatter'

module StableYamlFormatter
  # Provides Rake task integration
  class RakeTask < ::Rake::TaskLib
    # @return [String] name of the Rake task
    attr_accessor :name
    # @return [Array] arguments to be passed to Suggest.run
    attr_accessor :args

    # @param name [String] name of the Rake task
    # @param *args [Array] arguments to be passed to Normalize.call
    # @param &block [Proc] optional, evaluated inside the task definition
    def initialize(name = 'stable_yaml_formatter', *args, &block)
      @name = name
      @args = args
      yield(self) if block

      desc 'Normalize all YAML files in path'
      task(@name) { normalize }
    end

    # @return [void]
    def normalize
      ::StableYamlFormatter::Services::Normalize.call('**/*')
    end
  end
end
