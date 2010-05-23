require 'rubygems'
require 'timeout'

unless defined? RADIUS_LIB
  
  RADIUS_LIB = File.join(File.dirname(__FILE__), '..', 'lib')
  $LOAD_PATH << RADIUS_LIB
  
  require 'radius'
  require 'test/unit'
  
  module RadiusTestHelper
    class TestContext < Radius::Context; end
    
    def new_context
      Radius::Context.new do |c|
        c.define_tag("reverse"   ) { |tag| tag.expand.reverse }
        c.define_tag("capitalize") { |tag| tag.expand.upcase  }
        c.define_tag("echo"      ) { |tag| tag.attr['value']  }
        c.define_tag("wrap"      ) { |tag| "[#{tag.expand}]"  }
        c.define_tag("attr") do |tag|
          attributes = tag.attr
          output = []
          output << "{"
          attributes.keys.sort.each do |key|
            output << key.inspect
            output << "=>"
            output << attributes[key].inspect
            output << ", "
          end
          output.pop if output.last == ", "
          output << "}"
          output.join
        end
      end
    end
    
    def define_tag(name, options = {}, &block)
      @context.define_tag name, options, &block
    end
  end
end