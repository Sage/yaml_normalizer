# frozen_string_literal: true

require './tmpfix/rake_application'
require './spec/ci_helper'

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'inch/rake'

desc 'Check documentation coverage'
task :inch do
  inch_sh = 'bundle exec inch list --all --no-color . 2>&1'
  ci_task('CI inch', inch_sh) do |out, success|
    success && out.scan(/┃  ([ABCU]) /).uniq.flatten.eql?(['A'])
  end
end

RuboCop::RakeTask.new # add rake tasks "rubocop" and "rubocop:auto_correct"
Rake::Task[:rubocop].clear # remove default task "rake rubocop"

desc 'Run RuboCop'
task :rubocop do
  ci_task('CI rubocop', 'bundle exec rubocop -D 2>&1')

end

task :ci_spec do
  ci_task('CI spec', 'bundle exec rspec 2>&1') do |out, success|
    out_lines = out.split("\n")
    success &&= out_lines[-3].match?(/ 0 failures/)
    success &&= out_lines[-1].match?(/LOC \(100\.0%\) covered\.$/)
    success
  end
end

desc 'Mutation testing to check mutation coverage of current RSpec test suite'
task :mutant do
  mutant_sh = 'bundle exec mutant \
    --include lib \
    --require yaml_normalizer \
    --use rspec YamlNormalizer*  2>&1'

  ci_task('mutant', mutant_sh) do |out, success|
    success && out.split("\n")[-2] == 'Coverage:        100.00%'
  end
end

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new do |config|
  config.stats_options = ['--list-undoc', '--compact']
end

desc 'Continuous integration test suite (DEFAULT)'
task ci: %i[inch rubocop ci_spec mutant]

task default: :ci
