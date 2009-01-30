module Radius
  # Abstract base class for all parsing errors.
  class ParseError < StandardError
  end
  
  # Occurs when Parser cannot find an end tag for a given tag in a template or when
  # tags are miss-matched in a template.
  class MissingEndTagError < ParseError
    # Create a new MissingEndTagError object for +tag_name+. 
    def initialize(tag_name)
      super("end tag not found for start tag `#{tag_name}'")
    end
  end
  
  # Occurs when Context#render_tag cannot find the specified tag on a Context.
  class UndefinedTagError < ParseError
    # Create a new UndefinedTagError object for +tag_name+. 
    def initialize(tag_name)
      super("undefined tag `#{tag_name}'")
    end
  end
end