# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)

require './spec/ci_helper'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif !defined?(Mutant)
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec'
  end
end

require 'yaml_normalizer'

# Configure unit test suite
module SpecConfig
  # @return [String] path to files used in specs
  def data_path
    File.expand_path(File.join(File.dirname(__FILE__), 'data'))
  end
  module_function :data_path
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!
end
