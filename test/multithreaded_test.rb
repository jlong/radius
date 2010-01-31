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

  def test_each_thread_has_different_parser_context
    contexts = []
    Thread.new do
      contexts << Radius::Parser.new(@context).context
    end.join
    Thread.new do
      contexts << Radius::Parser.new(@context).context
    end.join
    assert_not_equal contexts.first, contexts.last
  end

  def test_each_thread_has_different_parser_globals
    globals = []
    Thread.new do
      globals << Radius::Parser.new(@context).context.globals
    end.join
    Thread.new do
      globals << Radius::Parser.new(@context).context.globals
    end.join
    assert_not_equal globals.first, globals.last
  end

=begin
  def test_runs_multithreaded
    threads = []
    1000.times do |t|
      threads << Thread.new do
        unless @context and @context.globals
          puts "NO CONTEXT: #{t} / #{self} / #{@context.inspect} / #{@context.globals.inspect}"
        end
        @context.globals.thread_id = Thread.current.object_id
        expected = "#{Thread.current.object_id} / #{@context.globals.object_id}"
        actual = @context.render_tag('thread')
        # Hash isn't threadsafe, so test immediately instead of storing
        assert_equal expected, actual
      end
    end
    threads.each{|t| t.join }
  end
=end

end
