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

  if RUBY_PLATFORM == 'java'
    require 'java'
    # call once before the thread to keep from using hidden require in a thread
    Radius::Parser.new
    def test_runs_multithreaded
      lock = java.lang.String.new("lock")
      threads = []
      1000.times do |t|
        thread = Thread.new do
                   parser = Radius::Parser.new(@context, :tag_prefix => 'r')
                   parser.context.globals.thread_id = Thread.current.object_id
                   expected = "#{Thread.current.object_id} / "+
                              "#{parser.context.globals.object_id}"
                   actual = parser.parse('<r:thread />')
                   assert_equal expected, actual
                 end
        lock.synchronized do
          threads << thread
        end
      end
      lock.synchronized do
        threads.each{|t| t.join }
      end
    end
  else
    def test_runs_multithreaded
      threads = []
      mute = Mutex.new
      1000.times do |t|
        thread = Thread.new do
                   parser = Radius::Parser.new(@context, :tag_prefix => 'r')
                   parser.context.globals.thread_id = Thread.current.object_id
                   expected = "#{Thread.current.object_id} / "+
                              "#{parser.context.globals.object_id}"
                   actual = parser.parse('<r:thread />')
                   assert_equal expected, actual
                 end
        mute.synchronize do
          threads << thread
        end
      end
      mute.synchronize do
        threads.each{|t| t.join }
      end
    end
  end

end
