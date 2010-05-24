if RUBY_PLATFORM != 'java'
  raise "JScanner is only for JRuby"
end

require 'java'
require 'radius/parser/java_scanner.jar'
module Radius
  include_package 'radius.parser'
  class JScanner
    def operate prefix, input
      Radius::JavaScanner.new(JRuby.runtime).operate(prefix, input)
    end
  end
end
