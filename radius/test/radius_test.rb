require 'test/unit'
require 'radius'

class TC_Template < Test::Unit::TestCase
	class TestContext < Template::Context
		def initialize
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
		
		def loop(attr)
			t = attr["times"].to_i
			result = ""
			t.times { result += yield }
			result
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
	end
	def setup
		@t = Template::Parser.new( :pre => "wow", :context => TestContext.new )
	end
	def test_parse_individual
		r = @t.parse_individual(%{<<wow:echo text="hello world!" />>})
		assert_equal("<hello world!>", r)

		r = @t.parse_individual(%{<wow:add param1="1" param2='2'/>})
		assert_equal("3", r)

		r = @t.parse_individual(%{a <wow:echo text="3 + 1 =" /> <wow:add param1="3" param2="1"/> b})
		assert_equal("a 3 + 1 = 4 b", r)
	end
	def test_parse_attributes
		r = @t.parse_attributes( %{ a="1" b='2'c="3"d="'" } )
		assert_equal( {"a" => "1", "b" => "2", "c" => "3", "d" => "'"}, r)
	end
	def test_parse
		r = @t.parse(%{<<wow:echo text="hello world!" />>})
		assert_equal("<hello world!>", r)

		r = @t.parse("<wow:reverse>test</wow:reverse>")
		assert_equal("test".reverse, r)

		r = @t.parse("<wow:reverse>test</wow:reverse> <wow:capitalize>test</wow:capitalize>")
		assert_equal("test".reverse + " TEST", r)
		
		r = @t.parse("<wow:echo text='hello world!' /> cool: <wow:reverse>a <wow:capitalize>test</wow:capitalize> b</wow:reverse> !")
		assert_equal("hello world! cool: b " + "TEST".reverse + " a !", r)
		
		r = @t.parse("<wow:reverse><wow:echo text='hello world!' /></wow:reverse>")
		assert_equal("hello world!".reverse, r)

		r = @t.parse("<wow:reverse><wow:capitalize>test</wow:capitalize> <wow:echo text='hello world!' /></wow:reverse>")
		assert_equal("TEST hello world!".reverse, r)
	end
	
	def test_parse__2
		r = @t.parse("<wow:reverse>12<wow:capitalize>at</wow:capitalize>34</wow:reverse>")
		assert_equal("12AT34".reverse, r)
	end
	
	def test_parse__loop
		r = @t.parse( %{<wow:count set="0" /><wow:loop times="5"><wow:count inc="true" /><wow:count /></wow:loop>} )
		assert_equal("12345", r)

		r = @t.parse( %{Three Stooges: <wow:each_item between=", ">"<wow:item />"</wow:each_item>} )
		assert_equal( %{Three Stooges: "Larry", "Moe", "Curly"}, r)
	end
	
	def test_parse__fail
		assert_raises(RuntimeError) { @t.parse("<wow:reverse>") }
	end
end