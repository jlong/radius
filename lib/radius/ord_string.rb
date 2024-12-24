module Radius
  module_function def OrdString(string_or_ord_string)
    if string_or_ord_string.is_a?(OrdString)
      string_or_ord_string
    else
      OrdString.new(string_or_ord_string)
    end
  end

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
