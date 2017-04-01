# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec'
  end
end

require 'stable_yaml_formatter'
RSpec.configure do |config|
  config.mock_with :rspec
end
