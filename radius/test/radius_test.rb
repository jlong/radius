require 'test/unit'
require 'radius'

module RadiusTestHelper
  class TestContext < Radius::Context; end
  
  def new_context
    Radius::Context.new do |c|
      c.define_tag("reverse"   ) { |tag| tag.expand.reverse }
      c.define_tag("capitalize") { |tag| tag.expand.upcase  }
    end
  end
  
  def define_tag(name, options = {}, &block)
    @context.define_tag name, options, &block
  end
end

class RadiusContextTest < Test::Unit::TestCase
  include RadiusTestHelper
  
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
    assert_not_equal Hash.new, @context.definitions
  end
  
  def test_with
    got = @context.with do |c|
      assert_equal @context, c
    end
    assert_equal @context, got
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
    @context = new_context
    @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
  end
  
  def test_initialize
    @parser = Radius::Parser.new
    assert_kind_of Radius::Context, @parser.context
  end
  
  def test_initialize_with_params
    @parser = Radius::Parser.new(TestContext.new)
    assert_kind_of TestContext, @parser.context
    
    @parser = Radius::Parser.new(:context => TestContext.new)
    assert_kind_of TestContext, @parser.context
    
    @parser = Radius::Parser.new('context' => TestContext.new)
    assert_kind_of TestContext, @parser.context
    
    @parser = Radius::Parser.new(:tag_prefix => 'r')
    assert_kind_of Radius::Context, @parser.context
    assert_equal 'r', @parser.tag_prefix
    
    @parser = Radius::Parser.new(TestContext.new, :tag_prefix => 'r')
    assert_kind_of TestContext, @parser.context
    assert_equal 'r', @parser.tag_prefix
  end
  
  def test_parse_individual_tags_and_parameters
    define_tag "add" do |tag|
      tag.attr["param1"].to_i + tag.attr["param2"].to_i
    end
    assert_parse_output "<3>", %{<<r:add param1="1" param2='2'/>>}
  end
  
  def test_parse_attributes
    define_tag 'test' do |tag|
      tag.attr.inspect
    end
    assert_parse_output %{{"a"=>"1", "b"=>"2", "c"=>"3", "d"=>"'"}}, %{<r:test a="1" b='2'c="3"d="'" />}
  end
  
  def test_parse_result_is_always_a_string
    define_tag("twelve") { 12 }
    assert_parse_output "12", "<r:twelve />"
  end
  
  def test_parse_double_tags
    assert_parse_output "test".reverse, "<r:reverse>test</r:reverse>"
    assert_parse_output "tset TEST", "<r:reverse>test</r:reverse> <r:capitalize>test</r:capitalize>"
  end
  
  def test_parse_tag_nesting
    define_tag("parent", :for => '')
    define_tag("parent:child", :for => '')
    define_tag("extra", :for => '')
    define_tag("nesting") { |tag| tag.nesting }
    define_tag("extra:nesting") { |tag| tag.nesting.gsub(':', ' > ') }
    define_tag("parent:child:nesting") { |tag| tag.nesting.gsub(':', ' * ') }
    assert_parse_output "nesting", "<r:nesting />"
    assert_parse_output "parent:nesting", "<r:parent:nesting />"
    assert_parse_output "extra > nesting", "<r:extra:nesting />"
    assert_parse_output "parent * child * nesting", "<r:parent:child:nesting />"
    assert_parse_output "parent > extra > nesting", "<r:parent:extra:nesting />"
    assert_parse_output "parent > child > extra > nesting", "<r:parent:child:extra:nesting />"
    assert_parse_output "parent:extra:child:nesting", "<r:parent:extra:child:nesting />"
    assert_parse_output "extra * parent * child * nesting", "<r:extra:parent:child:nesting />"
    assert_raises(Radius::UndefinedTagError) { @parser.parse("<r:child />") }
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
  
  def test_tag_option_for
    define_tag 'fun', :for => 'just for kicks'
    assert_parse_output 'just for kicks', '<r:fun />'
  end
  
  def test_tag_expose_option
    define_tag 'user', :for => users.first, :expose => ['name', :age]
    assert_parse_output 'John', '<r:user:name />'
    assert_parse_output '25', '<r:user><r:age /></r:user>'
    e = assert_raises(Radius::UndefinedTagError) { @parser.parse "<r:user:email />" }
    assert_equal "undefined tag `user:email'", e.message
  end
  
  def test_tag_expose_attributes_option_on_by_default
    define_tag 'user', :for => user_with_attributes
    assert_parse_output 'John', '<r:user:name />'
  end
  def test_tag_expose_attributes_set_to_false
    define_tag 'user_without_attributes', :for => user_with_attributes, :attributes => false
    assert_raises(Radius::UndefinedTagError) { @parser.parse "<r:user_without_attributes:name />" }
  end
  
  def test_tag_options_must_contain_a_for_option_if_methods_are_exposed
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
  def test_tag_option_expose_and_type_is_enumerable
    define_tag 'array', :for => [4, 2, 8, 5], :type => :enumerable, :item_tag => 'number', :expose => [:first, :last]
    assert_parse_output '4', '<r:array:first />'
    assert_parse_output '5', '<r:array:last />'
    assert_parse_output '(4)(2)(8)(5)', '<r:array:each>(<r:number />)</r:array:each>'
  end
  def test_tag_option_type_is_enumerable_with_complex_objects
    define_tag 'users', :for => users, :type => :enumerable, :item_tag => :user, :expose_as_items => :first,  :item_expose => [:name, :age]
    assert_parse_output "* John (25)\n* James (27)\n", "<r:users:each>* <r:user:name /> (<r:user:age />)\n</r:users:each>"
    assert_parse_output "John", "<r:users:max:name />"
    assert_parse_output "27", "<r:users:min><r:age /></r:users:min>"
    assert_parse_output "John", "<r:users:first:name />"
  end
  def test_tag_option_type_is_enumerable_with_no_objects
    define_tag 'array', :for => [], :type => :enumerable
    assert_parse_output '', '<r:array:max />'
    assert_parse_output '', '<r:array:each>(<r:item />)</r:array:each>'
    
    define_tag 'users', :for => [], :type => :enumerable, :item_expose => [:name, :age]
    assert_parse_output '', '<r:users:min:name />'
  end
  
  def test_tag_option_type_is_collection
    define_tag 'array', :for => [4, 2, 8, 5], :type => :collection
    assert_parse_output '4', '<r:array:first />'
    assert_parse_output '5', '<r:array:last />'
    assert_parse_output '(4)(2)(8)(5)', '<r:array:each>(<r:item />)</r:array:each>'
  end
  def test_tag_option_type_is_collection_with_complex_objects
    define_tag 'array', :for => users, :type => :collection, :item_expose => [:name, :age]
    assert_parse_output 'John', '<r:array:first:name />'
    assert_parse_output '27', '<r:array:last><r:age /></r:array:last>'
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
    
    class User
      attr_accessor :name, :age, :email, :friend
      def initialize(name, age, email)
        @name, @age, @email = name, age, email
      end
      def <=>(other)
        name <=> other.name
      end
    end
    
    class UserWithAttributes < User
      def attributes
        { :name => name, :age => age, :email => email }
      end
    end
    
    def users
      [
        User.new('John', 25, 'test@johnwlong.com'),
        User.new('James', 27, 'test@jameslong.com')
      ]
    end
    
    def user_with_attributes
      UserWithAttributes.new('John', 25, 'test@johnwlong.com')
    end
  
end