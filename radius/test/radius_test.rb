require 'test/unit'
require 'radius'

module RadiusTestHelper
  class TestContext < Radius::Context
    def initialize
      super
      @prefix = "r"
      define_tag("reverse"   ) { |tag| tag.expand.reverse }
      define_tag("capitalize") { |tag| tag.expand.upcase  }
    end
  end
  
  def define_tag(name, options = {}, &block)
    @context.define_tag name, options, &block
  end
end

class RadiusContextTest < Test::Unit::TestCase
  include RadiusTestHelper
  
  def setup
    @context = TestContext.new
  end
  
  def test_initialize
    @context = Radius::Context.new
    assert_equal 'radius', @context.prefix
  end
  
  def test_render_tag
    define_tag "hello" do |tag|
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
        "undefined tag `#{tag}' with attributes #{attr.inspect}"
      end
    end
    
    text = ''
    expected = %{undefined tag `undefined_tag' with attributes {"cool"=>"beans"}}
    assert_nothing_raised { text = @context.render_tag('undefined_tag', 'cool' => 'beans') }
    assert_equal expected, text
  end
  
  private
    
    def assert_render_tag_output(output, *render_tag_params)
      assert_equal output, @context.render_tag(*render_tag_params)
    end
  
end

class RadiusParserTest < Test::Unit::TestCase
  include RadiusTestHelper
  
  def setup
    @context = TestContext.new
    @parser = Radius::Parser.new(@context)
  end
  
  def test_parse_individual_tags_and_parameters
    define_tag "add" do |tag|
      tag.attr["param1"].to_i + tag.attr["param2"].to_i
    end
    assert_parse_individual_output "<3>", %{<<r:add param1="1" param2='2'/>>}
  end
  
  def test_parse_attributes
    r = @parser.parse_attributes(%{ a="1" b='2'c="3"d="'" })
    assert_equal({"a" => "1", "b" => "2", "c" => "3", "d" => "'"}, r)
  end
  
  def test_parse_result_is_always_a_string
    define_tag("twelve") { 12 }
    assert_parse_output "12", "<r:twelve />"
  end
  
  def test_parse_double_tags
    assert_parse_output "test".reverse, "<r:reverse>test</r:reverse>"
    assert_parse_output "tset TEST", "<r:reverse>test</r:reverse> <r:capitalize>test</r:capitalize>"
  end
  
  def test_parse_nested
    define_tag("outer") { |tag| tag.expand.reverse }
    define_tag("outer:inner") { |tag| ["renni", tag.expand].join }
    define_tag("outer:inner:heart") { "heart" }
    define_tag("outer:branch") { "branch" }
    assert_parse_output "inner", "<r:outer><r:inner /></r:outer>"
    assert_parse_output "renni", "<r:outer:inner />"
    assert_parse_output "heart", "<r:outer:inner:heart />"
    assert_parse_output "hcnarbinner", "<r:outer><r:inner><r:branch /></r:inner></r:outer>"
    assert_raises(Radius::UndefinedTagError) { @parser.parse("<r:inner />") }
  end
  
  def test_nesting
    define_tag("outer", :for => '')
    define_tag("outer:inner", :for => '')
    define_tag("nesting") { |tag| tag.nesting }
    assert_parse_output "nesting", "<r:nesting />"
    assert_parse_output "outer:nesting", "<r:outer><r:nesting /></r:outer>"
    assert_parse_output "outer:inner:nesting", "<r:outer><r:inner><r:nesting /></r:inner></r:outer>"
  end
  
  def test_parse_loops
    @item = nil
    define_tag "each" do |tag|
      result = []
      ["Larry", "Moe", "Curly"].each do |item|
        tag.set_item_for('each:item', item)
        result << tag.expand
      end
      result.join(tag.attr["between"] || "")
    end
    define_tag "each:item" do |tag|
      tag.item
    end
    assert_parse_output %{Three Stooges: "Larry", "Moe", "Curly"}, %{Three Stooges: <r:each between=", ">"<r:item />"</r:each>}
  end
  
  class User
    attr_accessor :name, :age, :email, :friend
    def initialize(name, age, email)
      @name, @age, @email = name, age, email
    end
  end
  
  def test_tag_option_for
    define_tag 'fun', :for => 'just for kicks'
    assert_parse_output 'just for kicks', '<r:fun />'
  end
  
  def test_tag_expose_option
    user = User.new('John', 25, 'test@johnwlong.com')
    define_tag 'user', :for => user, :expose => ['name', :age]
    assert_parse_output 'John', '<r:user:name />'
    assert_parse_output '25', '<r:user><r:age /></r:user>'
    e = assert_raises(Radius::UndefinedTagError) { @parser.parse "<r:user:email />" }
    assert_equal "undefined tag `user:email'", e.message
  end
  
  def test_tag_must_be_called_a_for_option_if_methods_are_exposed
    e = assert_raises(ArgumentError) { define_tag('fun', :expose => :today) { 'test' } }
    assert_equal "tag definition must contain a :for option when used with the :expose option", e.message
  end
  
  def test_tag_option_type_is_enumerable
    define_tag 'items', :for => [4, 2, 8, 5], :type => :enumerable
    assert_parse_output '4', '<r:items:size />'
    assert_parse_output '4', '<r:items:count />'
    assert_parse_output '4', '<r:items:length />'
    assert_parse_output '8', '<r:items:max />'
    assert_parse_output '2', '<r:items:min />'
    assert_parse_output '(4)(2)(8)(5)', '<r:items:each>(<r:item />)</r:items:each>'
  end
  def test_tag_option_for_and_type_is_enumerable
    define_tag 'array', :for => [4, 2, 8, 5], :type => :enumerable, :item_tag => 'number', :expose => [:first, :last]
    assert_parse_output '4', '<r:array:first />'
    assert_parse_output '5', '<r:array:last />'
    assert_parse_output '(4)(2)(8)(5)', '<r:array:each>(<r:number />)</r:array:each>'
  end
  def test_tag_option_type_is_enumerable_and_exposed_item
    items = [
      User.new('John', 25, 'test@johnwlong.com'),
      User.new('James', 27, 'test@jameslong.com')
    ]
    define_tag 'users', :for => items, :type => :enumerable, :item_tag => :user, :item_expose => [:name, :age]
    assert_parse_output "* John (25)\n* James (27)\n", "<r:users:each>* <r:user:name /> (<r:user:age />)\n</r:users:each>"
  end
  
  def test_tag_option_type_is_undefined
    e = assert_raises(ArgumentError) { define_tag 'test', :type => :undefined_type }
    assert_equal "Undefined type `undefined_type' in options hash", e.message
  end
  
  def test_parse_fail_on_missing_end_tag
    assert_raises(Radius::MissingEndTagError) { @parser.parse("<r:reverse>") }
    assert_raises(Radius::MissingEndTagError) { @parser.parse("<r:reverse><r:capitalize></r:reverse>") }
  end
  
  private
  
    def assert_parse_output(output, input, message = nil)
      r = @parser.parse(input)
      assert_equal(output, r, message)
    end
    
    def assert_parse_individual_output(output, input, message = nil)
      r = @parser.parse_individual(input)
      assert_equal(output, r, message)
    end
  
end