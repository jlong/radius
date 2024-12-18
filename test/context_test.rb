require 'test_helper'

class RadiusContextTest < Minitest::Test
  include RadiusTestHelper
  
  class SuperContext < Radius::Context
    attr_accessor :name
    def initialize(name)
      self.name = name
      super
    end
  end
  
  def setup
    @context = new_context
  end
  
  def test_initialize
    @context = Radius::Context.new
  end
  
  def test_initialize_with_block
    @context = Radius::Context.new do |c|
      assert_kind_of Radius::Context, c
      c.define_tag('test') { 'just a test' }
    end
    refute_equal Hash.new, @context.definitions
  end
  
  def test_initialize_with_arguments
    @context = SuperContext.new('arg') do |c|
      assert_kind_of Radius::Context, c
      c.define_tag('test') { 'just a test' }
    end
    assert_equal 'arg', @context.name
  end
  
  def test_with
    got = @context.with do |c|
      assert_equal @context, c
    end
    assert_equal @context, got
  end
  
  def test_render_tag
    define_global_tag "hello" do |tag|
      "Hello #{tag.attr['name'] || 'World'}!"
    end
    assert_render_tag_output 'Hello World!', 'hello'
    assert_render_tag_output 'Hello John!', 'hello', 'name' => 'John'
  end
  
  def test_render_tag__undefined_tag
    e = assert_raises(Radius::UndefinedTagError) { @context.render_tag('undefined_tag') }
    assert_equal "undefined tag `undefined_tag'", e.message
  end
  
  def test_tag_missing
    class << @context
      def tag_missing(tag, attr, &block)
        "undefined tag `#{tag}' with attributes #{attr.inspect.sub(" => ", "=>")}"
      end
    end
    
    text = ''
    expected = %{undefined tag `undefined_tag' with attributes {"cool"=>"beans"}}
    text = @context.render_tag('undefined_tag', 'cool' => 'beans')
    assert_equal expected, text
  end
  
  private
    
    def assert_render_tag_output(output, *render_tag_params)
      assert_equal output, @context.render_tag(*render_tag_params)
    end
  
end
