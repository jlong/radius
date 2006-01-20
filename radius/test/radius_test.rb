require 'test/unit'
require 'radius'

class RadiusTest < Test::Unit::TestCase
	class TestContext < Radius::Context
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
		@t = Radius::Parser.new( :pre => "wow", :context => TestContext.new )
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

__END__

class StoreContext < Radius::Context
  def initialize(options)
    @prefix = "r" # all tags must be prefixed with "rad"
    @user = options[:user]
    @cart = options[:cart]
    @session = options[:session]
  end
  
  # expose the @user object variable
  container(:user, :exposes => :user) do
    # Use protect() on an object that has been exposed to prevent access to
    # an attribute in a template. Conversly you could use the expose() method
    # to expose specific attributes to the template.
    protect :password
    
    # add a single tag that returns the session_id
    tag :session_id do |attributes|
      @session.id
    end
  end
  
  # expose the @cart object as the basket tag
  container(:basket, :exposes => :cart) do
    expand do |attributes|
      #
      # some initalization code with attributes before handling
      # content block
      #
      yeild
    end
    
    container(:items, :exposes => :item) do
      expand do |attributes|
        @cart.items.each do |@item|
          yield
        end
      end
    end
  end
  
  container :cart do
    expand do |attributes|
      yield
    end
  end
end

class User
  attr_accessor :name, :login, :password, :email
  def initialize(name, login, password, email)
    @name, @login, @password, @email = name, login, password, email
  end
end

class Session
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end

class Cart
  attr_accessor :items
  
  def initialize(*items)
    @items = [items].flatten
  end
  
  def total
    @items.map { |line_item| line_item.total }
  end
end

class LineItem
  attr_accessor :name, :description, :quantity, :item_price
  def intialize(name, description, price, quantity)
    @name, @description, @price, @quantity = name, description, price, quantity
  end
  def full_price
    @price * @quantity
  end
end

receipt = <<-RECEIPT
<p><r:user:name />, thank you for shopping with us! An order summary
  is printed below for your convinience. Please print a copy for your records.</p>
<r:cart>
  <table>
    <thead>
      <tr>
        <td>Product</td>
        <td>Price</td>
        <td>Quantity</td>
        <td>Totals</td>
      </tr>
    </thead>
    <tbody>
      <r:items>
        <tr>
          <td>
            <strong><r:name /></strong><br >
            <r:description />
          </td>
          <td><r:price /></td>
          <td><r:quanity /></td>
          <td><r:full_price /></td>
        </tr>
      </r:items>
    </tbody>
    <tr>
      <td colspan="3">Total</td>
      <td><r:total /></td>
    </tr>
  </table>
</r:cart>
RECEIPT

user = User.new('John', 'johnboy', 'm@x!mu5', 'johnboy@maximus.com')
cart = Cart.new(
  LineItem.new('15in PowerBook', "Apple's premium notebook computer.", 1995.98, 1),
  LineItem.new('Mac Notebook Case', "A beautiful black notebook case designed for Apple Powerbooks.", 54.05, 1)
)
session = Session.new('a4bd386e512bacd581')

context = StoreContext.new(
  :user => user,
  :cart => cart,
  :session => session
)

template = Radius::Template.new(
  :text => receipt,
  :context => context
)

template.compile! # based on context parses text into abstract syntax tree
puts template.expand # outputs expanded template

# alternate usage
parser = Radius::Parser.new(context)
puts parser.parse(receipt) # compiles and outputs expanded template

# another alternate
puts Radius.parse(receipt, context)

template = Radius::Template.compile('template to compile')
template.expand(data)

output = Radius.parse(string, data)