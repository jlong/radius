require 'test/unit'
require 'radius'

class TestContext < Radius::Context
  def build_tags
    @prefix = "test"
    @items = ["Larry", "Moe", "Curly"]
    
    tag "echo" do
      attr["text"]
    end
    
    tag "reverse" do
      work.reverse
    end
    
    tag "capitalize" do
      work.upcase
    end
    
    tag "count" do
      case
      when attr["set"]
        @count = attr["set"].to_i
        ""
      when attr["inc"] == "true"
        @count = (@count || 0) + 1
        ""
      else
        @count.to_s       
      end
    end
  end
end

module RadiusTestHelper
  def define_tag(name, &block)
    @context.tag name, &block
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
    define_tag "hello" do
      "Hello #{attr['name'] || 'World'}!"
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
    assert_nothing_raised { text = @context.render_tag('undefined_tag', 'cool' => 'beans') }
    
    expected = %{undefined tag `undefined_tag' with attributes {"cool"=>"beans"}}
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
    define_tag "add" do
      attr["param1"].to_i + attr["param2"].to_i
    end
    assert_parse_individual_output "<hello world!>", %{<<test:echo text="hello world!" />>}
    assert_parse_individual_output "3", %{<test:add param1="1" param2='2'/>}
    assert_parse_individual_output "a 3 + 1 = 4 b", %{a <test:echo text="3 + 1 =" /> <test:add param1="3" param2="1"/> b}
  end
  
  def test_parse_attributes
    r = @parser.parse_attributes(%{ a="1" b='2'c="3"d="'" })
    assert_equal({"a" => "1", "b" => "2", "c" => "3", "d" => "'"}, r)
  end
  
  def test_parse_result_is_always_a_string
    define_tag("twelve") { 12 }
    assert_parse_output "12", "<test:twelve />"
  end
  
  def test_parse_double
    assert_parse_output "test".reverse, "<test:reverse>test</test:reverse>"
    assert_parse_output "tset TEST", "<test:reverse>test</test:reverse> <test:capitalize>test</test:capitalize>"
  end
  def test_parse_multiple_tags
    assert_parse_output "hello world! cool: b TSET a !", "<test:echo text='hello world!' /> cool: <test:reverse>a <test:capitalize>test</test:capitalize> b</test:reverse> !"
  end
  def test_parse_nested
    assert_parse_output "!dlrow olleh", "<test:reverse><test:echo text='hello world!' /></test:reverse>"
  end
  def test_parse_nested_double_tags
    assert_parse_output "!dlrow olleh TSET", "<test:reverse><test:capitalize>test</test:capitalize> <test:echo text='hello world!' /></test:reverse>"
    assert_parse_output "43TA21", "<test:reverse>12<test:capitalize>at</test:capitalize>34</test:reverse>"
  end
  def test_parse_nested
    define_tag("outer") { work.reverse }
    define_tag("outer:inner") { ["renni", work].join }
    define_tag("outer:inner:heart") { "heart" }
    define_tag("outer:branch") { "branch" }
    assert_parse_output "inner", "<test:outer><test:inner /></test:outer>"
    assert_parse_output "renni", "<test:outer:inner />"
    assert_parse_output "heart", "<test:outer:inner:heart />"
    assert_parse_output "hcnarbinner", "<test:outer><test:inner><test:branch /></test:inner></test:outer>"
    assert_raises(Radius::UndefinedTagError) { @parser.parse("<test:inner />") }
  end
  def test_parse_loop
    define_tag "each" do
      result = []
      @items.each { |@item| result << work }
      @item = nil
      result.join(attr["between"] || "")
    end
    define_tag "item"
    assert_parse_output %{Three Stooges: "Larry", "Moe", "Curly"}, %{Three Stooges: <test:each between=", ">"<test:item />"</test:each>}
  end
  def test_parse__fail_on_missing_end_tag
    assert_raises(Radius::MissingEndTagError) { @parser.parse("<test:reverse>") }
    assert_raises(Radius::MissingEndTagError) { @parser.parse("<test:reverse><test:capitalize></test:reverse>") }
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