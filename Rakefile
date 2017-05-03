# frozen_string_literal: true

require './tmpfix/rake_application'

require 'English'
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'inch/rake'

# rubocop:disable Metrics/MethodLength
def ci_run(cmd)
  time = Time.new
  output = StringIO.new
  IO.popen(cmd) do |f|
    until f.eof?
      bit = f.getc
      output << bit
      $stdout.putc bit
    end
  end
  output.rewind
  [output.read, $CHILD_STATUS.success?, time]
ensure
  output.close
end

def ci_msg(msg, check, time)
  puts '################################################'
  puts "Finished in #{format('%.2f', Time.new - time)} seconds."
  print '[PASSED] ' if check
  print '[FAILED] ' unless check
  puts msg
  puts '################################################'
  abort unless check
  check
end

task :ci_inch do
  inch_sh = 'bundle exec inch list --all --no-color . 2>&1'
  out, success, time = ci_run(inch_sh)

  check = success && out.scan(/┃  ([ABCU]) /).uniq.flatten.eql?(['A'])

  ci_msg 'CI inch', check, time
end

task :ci_spec do
  spec_sh = 'bundle exec rake spec 2>&1'
  out, success, time = ci_run(spec_sh)
  out_lines = out.split("\n")

  check = success
  check &&= out_lines[-3].match?(/ 0 failures/)
  check &&= out_lines[-1].match?(/LOC \(100\.0%\) covered\.$/)

  ci_msg 'CI spec', check, time
end

task :ci_rubocop do
  rubocop_sh = 'bundle exec rubocop -D 2>&1'
  out, success, time = ci_run(rubocop_sh)

  check = success && out.split("\n")[-1].match?(/, no offenses detected$/)

  ci_msg('CI rubocop', check, time)
end

task :ci_mutant do
  mutant_sh = 'bundle exec rake mutant 2>&1'
  out, success, time = ci_run(mutant_sh)
  check = success && out.split("\n")[-2] == 'Coverage:        100.00%'

  ci_msg('CI mutant', check, time)
end

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new do |config|
  config.stats_options = ['--list-undoc', '--compact']
end
Inch::Rake::Suggest.new

desc 'Mutation testing to check mutation coverage of current RSpec test suite'
task :mutant do
  puts `bundle exec mutant \
    --include lib \
    --require yaml_normalizer \
    --use rspec YamlNormalizer*`
end

desc 'Continuous integration test suite'
task ci: %i[ci_inch ci_rubocop ci_spec ci_mutant]

task default: :ci
