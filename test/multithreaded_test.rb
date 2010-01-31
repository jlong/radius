require 'test/unit'
require 'radius'

class MultithreadTest < Test::Unit::TestCase

  def setup
    Thread.abort_on_exception
    @context = Radius::Context.new do |c|
      c.define_tag('thread') do |tag|
        "#{tag.locals.thread_id} / #{tag.globals.object_id}"
      end
    end
  end

  def test_runs_multithreaded
    threads = []
    1000.times do |t|
      threads << Thread.new do
        parser = Radius::Parser.new(@context, :tag_prefix => 'r')
        parser.context.globals.thread_id = Thread.current.object_id
        expected = "#{Thread.current.object_id} / #{parser.context.globals.object_id}"
        actual = parser.parse('<r:thread />')
        p actual
        assert_equal expected, actual
      end
    end
    threads.each{|t| t.join }
  end

end
