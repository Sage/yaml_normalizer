# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)

require './spec/ci_helper'

ENV['ENV'] = 'test'
unless defined?(Mutant)
  require 'simplecov'
  require 'simplecov_json_formatter'

  SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
  SimpleCov.start do
    add_filter '/spec'
  end
end

require 'yaml_normalizer'

Dir.foreach(File.join(File.dirname(__FILE__), 'shared_examples')) do |f|
  next if ['.', '..'].include?(f)

  require File.join(File.dirname(__FILE__), 'shared_examples', f)
end

# Configure unit test suite
module SpecConfig
  module_function

  # @return [String] path to files used in specs
  def data_path
    File.expand_path(File.join(File.dirname(__FILE__), 'data'))
  end
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!

  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
