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
            thread_context = @context.dup
            parser = Radius::Parser.new(thread_context, :tag_prefix => 'r')
            parser.context.globals.thread_id = Thread.current.object_id
            expected = "#{Thread.current.object_id} / #{parser.context.globals.object_id}"
            result = parser.parse('<r:thread />')

            local_results << {
              result: result,
              thread_id: Thread.current.object_id,
              iteration: local_results.size
            }

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
      failed_items = []
      5.times { failed_items << failures.pop unless failures.empty? }
      "Thread failures detected:\n#{failures.size} times:\n#{failed_items.join("\n")}"
    end

    assert(failures.empty?, failure_message)
    total_results = results.flatten.uniq.size
    expected_unique_results = thread_count * iterations_per_thread

    if total_results != expected_unique_results
      duplicates = results.flatten.group_by { |r| r[:result] }
                         .select { |_, v| v.size > 1 }

      puts "\nDuplicates found:"
      duplicates.each do |result, occurrences|
        puts "\nResult: #{result[:result]}"
        occurrences.each { |o| puts "  Thread: #{o[:thread_id]}, Iteration: #{o[:iteration]}" }
      end
    end

    assert_equal expected_unique_results, total_results,
      "Expected #{expected_unique_results} unique results (#{thread_count} threads × #{iterations_per_thread} iterations)"
  end

end
