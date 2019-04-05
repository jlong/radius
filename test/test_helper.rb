require 'simplecov'
SimpleCov.start do
  add_filter 'test'
end

require 'coveralls'
if ENV['COVERALLS']
  Coveralls.wear!
end

require 'timeout'

unless defined? RADIUS_LIB

  RADIUS_LIB = File.join(File.dirname(__FILE__), '..', 'lib')
  $LOAD_PATH << RADIUS_LIB

  require 'radius'
  require 'minitest'

  module RadiusTestHelper
    class TestContext < Radius::Context; end

    def new_context
      Radius::Context.new do |c|
        c.define_tag("reverse"   ) { |tag| tag.expand.reverse }
        c.define_tag("capitalize") { |tag| tag.expand.upcase  }
        c.define_tag("echo"      ) { |tag| tag.attr['value']  }
        c.define_tag("wrap"      ) { |tag| "[#{tag.expand}]"  }
        c.define_tag("attr") do |tag|
          kv = tag.attr.keys.sort.collect{|k| "#{k.inspect}=>#{tag[k].inspect}"}
          "{#{kv.join(', ')}}"
        end
      end
    end

    def define_tag(name, options = {}, &block)
      @parser.context.define_tag name, options, &block
    end

    def define_global_tag(name, options = {}, &block)
      @context.define_tag name, options, &block
    end
  end
end
require 'minitest/autorun'
