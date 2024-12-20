module Radius
  class DelegatingOpenStruct # :nodoc:
    attr_accessor :object
    
    def initialize(object = nil)
      @object = object
      @hash = {}
    end

    def dup
      self.class.new.tap do |copy|
        copy.instance_variable_set(:@hash, @hash.dup)
        copy.object = @object
      end
    end
    
    def method_missing(method, *args, &block)
      return super if args.size > 1
      
      symbol = method.to_s.chomp('=').to_sym
      
      if method.to_s.end_with?('=')
        @hash[symbol] = args.first
      else
        @hash.fetch(symbol) { @object&.public_send(method, *args, &block) }
      end
    end

    def respond_to_missing?(method, include_private = false)
      (args.size <= 1) || super
    end
  end
end
