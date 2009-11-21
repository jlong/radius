require 'test/unit'
require 'radius'

class MultithreadTest < Test::Unit::TestCase
  def setup
    Thread.abort_on_exception
    @context = Radius::Context.new do |c|
      c.define_tag('thread') do |tag|
        "#{tag.locals.thread_id.to_s} / #{tag.globals.object_id}"
      end
    end
  end

  def test_each_thread_has_different_globals
    globals = []
    Thread.new do
      globals << @context.globals
    end.join
    Thread.new do
      globals << @context.globals
    end.join
    assert_not_equal globals.first, globals.last
  end

  def test_runs_multithreaded
    threads = []
    outputs = {}
    expected_outputs = {}
    1000.times do |t|
      threads << Thread.new do
        @context.globals.thread_id = Thread.current.object_id
        outputs[Thread.current.object_id] = @context.render_tag('thread')
        expected_outputs[Thread.current.object_id] = "#{Thread.current.object_id} / #{@context.globals.object_id}"
      end
    end
    threads.each{|t| t.join }
    outputs.each do |tid, op|
      assert_equal expected_outputs[tid], op, "Thread: #{tid}"
    end
  end


end
