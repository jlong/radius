require 'test/unit'
require 'radius'

class TestContext < Radius::Context
  def build_tags
    @prefix = "test"
    @items = ["Larry", "Moe", "Curly"]
    
    tag "echo" do
      attr["text"]
    end
    
    tag "add" do
      (attr["param1"].to_i + attr["param2"].to_i).to_s
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
    
    tag "repeat" do
      string = ''
      (attr['count'] || '1').to_i.times { string << work }
      string
    end
    
    tag "each_item" do
      result = []
      @items.each { |@item| result << work }
      @item = nil
      result.join(attr["between"] || "")
    end
  
    tag "item"
    
    tag "hello" do
      "Hello #{attr['name'] || 'World'}!"
    end
  end
end

class RadiusContextTest < Test::Unit::TestCase
  def setup
    @context = TestContext.new
  end
  
  def test_initialize
    @context = Radius::Context.new
    assert_equal 'radius', @context.prefix
  end
  
  def test_render_tag__individual
    text = @context.render_tag('hello')
    assert_equal('Hello World!', text)

    text = @context.render_tag('hello', 'name' => 'John')
    assert_equal('Hello John!', text)
  end
  
  def test_render_tag__container
    text = @context.render_tag('repeat', 'count' => '5') { 'o' }
    assert_equal('ooooo', text)
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
end

class RadiusParserTest < Test::Unit::TestCase
  def setup
    @t = Radius::Parser.new(TestContext.new)
  end
  
  def test_parse_individual
    assert_parse_individual_output "<hello world!>", %{<<test:echo text="hello world!" />>}
    assert_parse_individual_output  "3", %{<test:add param1="1" param2='2'/>}
    assert_parse_individual_output "a 3 + 1 = 4 b", %{a <test:echo text="3 + 1 =" /> <test:add param1="3" param2="1"/> b}
  end
  
  def test_parse_attributes
    r = @t.parse_attributes(%{ a="1" b='2'c="3"d="'" })
    assert_equal({"a" => "1", "b" => "2", "c" => "3", "d" => "'"}, r)
  end
  
  def test_parse__double
    assert_parse_output "test".reverse, "<test:reverse>test</test:reverse>"
    assert_parse_output "tset TEST", "<test:reverse>test</test:reverse> <test:capitalize>test</test:capitalize>"
  end
  def test_parse
    assert_parse_output "hello world! cool: b TSET a !", "<test:echo text='hello world!' /> cool: <test:reverse>a <test:capitalize>test</test:capitalize> b</test:reverse> !"
    assert_parse_output "!dlrow olleh", "<test:reverse><test:echo text='hello world!' /></test:reverse>"
    assert_parse_output "!dlrow olleh TSET", "<test:reverse><test:capitalize>test</test:capitalize> <test:echo text='hello world!' /></test:reverse>"
    assert_parse_output "43TA21", "<test:reverse>12<test:capitalize>at</test:capitalize>34</test:reverse>"
  end
  def test_parse__looping
    assert_parse_output "12345", %{<test:count set="0" /><test:repeat count="5"><test:count inc="true" /><test:count /></test:repeat>}
    assert_parse_output %{Three Stooges: "Larry", "Moe", "Curly"}, %{Three Stooges: <test:each_item between=", ">"<test:item />"</test:each_item>}
  end
  
  def test_parse__fail_on_no_end_tag
    assert_raises(Radius::MissingEndTagError) { @t.parse("<test:reverse>") }
    assert_raises(Radius::MissingEndTagError) { @t.parse("<test:reverse><test:capitalize></test:reverse>") }
  end
  
  private
  
    def assert_parse_output(output, input, message = nil)
      r = @t.parse(input)
      assert_equal(output, r, message)
    end
    
    def assert_parse_individual_output(output, input, message = nil)
      r = @t.parse_individual(input)
      assert_equal(output, r, message)
    end
  
end