module Radius
  module Utility # :nodoc:
    def self.symbolize_keys(hash)
      new_hash = {}
      hash.keys.each do |k|
        new_hash[k.to_s.intern] = hash[k]
      end
      new_hash
    end
    
    def self.impartial_hash_delete(hash, key)
      string = key.to_s
      symbol = string.intern
      value1 = hash.delete(symbol)
      value2 = hash.delete(string)
      value1 || value2
    end
    
    def self.constantize(camelized_string)
      raise "invalid constant name `#{camelized_string}'" unless camelized_string.split('::').all? { |part| part =~ /^[A-Za-z]+$/ }
      Object.module_eval(camelized_string)
    end
    
    def self.camelize(underscored_string)
      string = ''
      underscored_string.split('_').each { |part| string << part.capitalize }
      string
    end

    if RUBY_VERSION[0,3] == '1.8'
      def self.array_to_s(c)
        c.to_s
      end
    else
      def self.array_to_s(c)
        c.map{|x| (x.is_a?(Array) ? array_to_s(x) : x.to_s).force_encoding(Encoding::UTF_8) }.join
      end
    end
  end
end