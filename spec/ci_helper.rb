# frozen_string_literal: true

require 'English'

# Helper method that wraps CI functionality
# If called with a block, ci_task expects the block to return a Boolean
# indicating the overall success of the task.
# @example
# @param name [String] name of the task
# @param cmd [String] command to be executed in child process
def ci_task(name, cmd)
  ci_begin_msg(name)
  out, success, time = ci_run(cmd)

  success = yield(out, success) if block_given?

  ci_end_msg(name, success, time)
end

# Helper method that captures output and returns it as String together with the
# command's success status and it's start time. run_ci optionally prints the
# command's output to the original output as well
# @param cmd [String] command to be executed in child process
# @param tee [Boolean] true if output should be printed (default)
# rubocop:disable Metrics/MethodLength
def ci_run(cmd, tee = true)
  time = Time.new
  output = StringIO.new
  IO.popen(cmd) do |f|
    until f.eof?
      bit = f.getc
      output << bit
      $stdout.putc bit if tee
    end
  end
  output.rewind
  [output.read, $CHILD_STATUS.success?, time]
ensure
  output.close
end

# Helper method used to print out a message before running a CI task
# @param msg [String] the message to be printed
def ci_begin_msg(msg)
  puts '################################################'
  puts "Starting #{msg} at #{Time.new}."
  puts '################################################'
end

# Helper method used to print out a message after running a CI task
# @param msg [String] the message to be printed
# @param success [Boolean] true is CI task passed, false if it failed
# @param time [Time] the message to be printed
def ci_end_msg(msg, success, time)
  puts '################################################'
  puts "Finished in #{format('%.2f', Time.new - time)} seconds."
  print '[PASSED] ' if success
  print '[FAILED] ' unless success
  puts msg
  puts '################################################'
  abort unless success
  success
end
