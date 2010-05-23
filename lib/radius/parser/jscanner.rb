if RUBY_PLATFORM != 'java'
  raise "JScanner is only for JRuby"
end

require 'radius/parser/java_scanner.jar'
module Radius
  include_package 'radius.parser'
  class JScanner
    def operate prefix, input
      list = Radius::JavaScanner.new.operate(prefix, input)
      list.collect{|x| translate_from_java_tag(x) }
    end

    def translate_from_java_tag tag
      if tag.passthrough
        tag.name
      else
        {
          :prefix => tag.prefix,
          :name => tag.name,
          :attrs => translate_attributes(tag.attributes),
          :flavor => case tag.flavor
                     when Radius::JavaScanner::Flavor::OPEN then :open
                     when Radius::JavaScanner::Flavor::CLOSE then :close
                     when Radius::JavaScanner::Flavor::SELF then :self
                     else :tasteless
                     end
        }
      end
    end

    def translate_attributes jattr
      rv = {}
      jattr.key_set.each do |key|
        rv[key] = jattr[key]
      end
      rv
    end
  end
end
