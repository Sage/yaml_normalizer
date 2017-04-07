# frozen_string_literal: true

require 'yaml_normalizer'

module YamlNormalizer
  # Provides Rake task integration
  class RakeTask < ::Rake::TaskLib
    # @return [String] name of the Rake task
    attr_accessor :name
    # @return [Array] arguments to be passed to Suggest.run
    attr_accessor :args

    # @param name [String] name of the Rake task
    # @param *args [Array] arguments to be passed to Normalize.call
    # @param &block [Proc] optional, evaluated inside the task definition
    def initialize(name = 'yaml_normalizer', *args, &block)
      @name = name
      @args = args
      yield(self) if block

      desc 'Normalize all YAML files in path'
      task(@name) { normalize }
    end

    # @return [void]
    def normalize
      ::YamlNormalizer::Services::Normalize.call('**/*')
    end
  end
end
