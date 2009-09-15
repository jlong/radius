require File.join(File.dirname(__FILE__), 'test_helper')

class QuickstartTest < Test::Unit::TestCase

  def test_example_1
    context = Radius::Context.new
    context.define_tag "hello" do |tag|
      "Hello #{tag.attr['name'] || 'World'}!"
    end
    parser = Radius::Parser.new(context)
    assert_equal "<p>Hello World!</p>", parser.parse('<p><radius:hello /></p>')
    assert_equal "<p>Hello John!</p>", parser.parse('<p><radius:hello name="John" /></p>')
  end
  
  def test_example_2
    require 'redcloth'
    context = Radius::Context.new
    context.define_tag "textile" do |tag|
      contents = tag.expand
      RedCloth.new(contents).to_html
    end
    parser = Radius::Parser.new(context)
    assert_equal "<h1>Hello <strong>World</strong>!</h1>", parser.parse('<radius:textile>h1. Hello **World**!</radius:textile>')
  end

end