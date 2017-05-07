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

  ci_begin_msg('CI inch')
  out, success, time = ci_run(inch_sh)

  check = success && out.scan(/┃  ([ABCU]) /).uniq.flatten.eql?(['A'])

  ci_end_msg 'CI inch', check, time
end

RuboCop::RakeTask.new # add rake tasks "rubocop" and "rubocop:auto_correct"
Rake::Task[:rubocop].clear # remove default task "rake rubocop"

desc 'Run RuboCop'
task :rubocop do
  rubocop_sh = 'bundle exec rubocop -D 2>&1'

  ci_begin_msg('CI rubocop')
  out, success, time = ci_run(rubocop_sh)

  check = success && out.split("\n")[-1].match?(/, no offenses detected$/)

  ci_end_msg('CI rubocop', check, time)
end

task :ci_spec do
  spec_sh = 'bundle exec rake spec 2>&1'
  ci_begin_msg('CI spec')

  out, success, time = ci_run(spec_sh)
  out_lines = out.split("\n")

  check = success
  check &&= out_lines[-3].match?(/ 0 failures/)
  check &&= out_lines[-1].match?(/LOC \(100\.0%\) covered\.$/)

  ci_end_msg 'CI spec', check, time
end

desc 'Mutation testing to check mutation coverage of current RSpec test suite'
task :mutant do
  mutant_sh = 'bundle exec mutant \
    --include lib \
    --require yaml_normalizer \
    --use rspec YamlNormalizer*  2>&1'

  ci_begin_msg('mutant')
  out, success, time = ci_run(mutant_sh)
  check = success && out.split("\n")[-2] == 'Coverage:        100.00%'

  ci_end_msg('mutant', check, time)
end

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new do |config|
  config.stats_options = ['--list-undoc', '--compact']
end

desc 'Continuous integration test suite (DEFAULT)'
task ci: %i[inch rubocop ci_spec mutant]

task default: :ci
