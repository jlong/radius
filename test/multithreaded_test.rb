require 'thread'
require 'test_helper'
require 'radius'
require 'etc'

class MultithreadTest < Minitest::Test

  def setup
    Thread.abort_on_exception = true
    @context = Radius::Context.new do |c|
      c.define_tag('thread') do |tag|
        "#{tag.locals.thread_id} / #{tag.globals.object_id}"
      end
    end
  end

  def test_runs_multithreaded
    thread_count = [Etc.nprocessors, 16].min
    iterations_per_thread = 500
    failures = Queue.new
    results = Array.new(thread_count) { [] }
    threads = []

    thread_count.times do |i|
      threads << Thread.new do
        local_results = []
        iterations_per_thread.times do
          begin
            parser = Radius::Parser.new(@context, :tag_prefix => 'r')
            parser.context.globals.thread_id = Thread.current.object_id
            expected = "#{Thread.current.object_id} / #{parser.context.globals.object_id}"
            result = parser.parse('<r:thread />')

            local_results << result

            failures << "Expected: #{expected}, Got: #{result}" unless result == expected
          rescue => e
            failures << "Thread #{Thread.current.object_id} failed: #{e.message}\n#{e.backtrace.join("\n")}"
          end
        end
        results[i] = local_results
      end
    end

    threads.each(&:join)

    # Only try to show failures if there are any
    failure_message = if failures.empty?
      nil
    else
      "Thread failures detected:\n#{failures.size} times:\n#{failures.pop(5).join("\n")}"
    end

    assert(failures.empty?, failure_message)
    total_results = results.flatten.uniq.size
    expected_unique_results = thread_count * iterations_per_thread
    assert_equal expected_unique_results, total_results,
      "Expected #{expected_unique_results} unique results (#{thread_count} threads × #{iterations_per_thread} iterations)"
  end

end
