require 'test/unit'
require 'radius'

class TestContext < Radius::Context
  def initialize
    @prefix = "test"
    @items = ["Larry", "Moe", "Curly"]
  end
  
  def echo(attr)
    attr["text"]
  end
  
  def add(attr)
    (attr["param1"].to_i + attr["param2"].to_i).to_s
  end
  
  def reverse(attr)
    yield.reverse
  end
  
  def capitalize(attr)
    yield.upcase
  end
  
  def count(attr)
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
  
  def repeat(attr)
    string = ''
    (attr['count'] || '1').to_i.times { string << yield }
    string
  end
  
  def each_item(attr)
    result = []
    @items.each { |@item| result << yield }
    @item = nil
    result.join(attr["between"] || "")
  end
  
  def item(attr)
    @item
  end
  
  def hello(attr)
    "Hello #{attr['name'] || 'World'}!"
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
  
  def test_render_tag__undefined_tag_with_wrong_signature
    class << @context
      def helper_method
      end
    end
    assert_raises(Radius::UndefinedTagError) { @context.render_tag('helper_method') }
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
    @t = Radius::Parser.new(TestContext.new )
  end
  
  def test_parse_individual
    r = @t.parse_individual(%{<<test:echo text="hello world!" />>})
    assert_equal("<hello world!>", r)

    r = @t.parse_individual(%{<test:add param1="1" param2='2'/>})
    assert_equal("3", r)

    r = @t.parse_individual(%{a <test:echo text="3 + 1 =" /> <test:add param1="3" param2="1"/> b})
    assert_equal("a 3 + 1 = 4 b", r)
  end
  
  def test_parse_attributes
    r = @t.parse_attributes(%{ a="1" b='2'c="3"d="'" })
    assert_equal({"a" => "1", "b" => "2", "c" => "3", "d" => "'"}, r)
  end
  
  def test_parse
    r = @t.parse(%{<<test:echo text="hello world!" />>})
    assert_equal("<hello world!>", r)

    r = @t.parse("<test:reverse>test</test:reverse>")
    assert_equal("test".reverse, r)

    r = @t.parse("<test:reverse>test</test:reverse> <test:capitalize>test</test:capitalize>")
    assert_equal("tset TEST", r)
    
    r = @t.parse("<test:echo text='hello world!' /> cool: <test:reverse>a <test:capitalize>test</test:capitalize> b</test:reverse> !")
    assert_equal("hello world! cool: b TSET a !", r)
    
    r = @t.parse("<test:reverse><test:echo text='hello world!' /></test:reverse>")
    assert_equal("!dlrow olleh", r)

    r = @t.parse("<test:reverse><test:capitalize>test</test:capitalize> <test:echo text='hello world!' /></test:reverse>")
    assert_equal("!dlrow olleh TSET", r)

    r = @t.parse("<test:reverse>12<test:capitalize>at</test:capitalize>34</test:reverse>")
    assert_equal("43TA21", r)
  end
  def test_parse__looping
    r = @t.parse(%{<test:count set="0" /><test:repeat count="5"><test:count inc="true" /><test:count /></test:repeat>})
    assert_equal("12345", r)

    r = @t.parse(%{Three Stooges: <test:each_item between=", ">"<test:item />"</test:each_item>})
    assert_equal(%{Three Stooges: "Larry", "Moe", "Curly"}, r)
  end
  
  def test_parse__fail_on_no_end_tag
    assert_raises(Radius::MissingEndTagError) { @t.parse("<test:reverse>") }
  end
  def test_parse__fail_on_no_end_tag_2
    assert_raises(Radius::MissingEndTagError) { @t.parse("<test:reverse><test:capitalize></test:reverse>") }
  end
end