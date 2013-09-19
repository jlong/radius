module Radius
  class OrdString < String
    unless "a"[0] == 97 # test for lower than Ruby 1.9
      def [](*args)
        if args.size == 1 && args.first.is_a?(Integer)
          slice(args.first).ord
        else
          super
        end
      end
    end
  end
end