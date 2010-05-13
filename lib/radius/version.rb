module Radius
  module Version
    Major = '1'
    Minor = '1'
    Tiny  = '0'
    
    class << self
      def to_s
        [Major, Minor, Tiny].join('.')
      end
      alias :to_str :to_s
    end
  end
end
