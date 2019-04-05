module Radius
  class OrdString < String
    def [](*args)
      if args.size == 1 && args.first.is_a?(Integer)
        slice(args.first).ord
      else
        super
      end
    end
  end
end
