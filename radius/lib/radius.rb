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
    # Create a new MissingEndTagError object for +tag_name+. 
    def initialize(tag_name)
      super("undefined tag `#{tag_name}'")
    end
  end
  
  #
  # An abstract class for creating a Context. A context defines the tags that
  # are available for use in a template.
  #
  class Context
    # The prefix attribute controls the string of text that is helps the parser
    # identify template tags. By default this attribute is set to "radius", but
    # you may want to override this when creating your own contexts.
    attr_accessor :prefix
    
    # Creates a new Context object.
    def initialize
      @prefix = 'radius'
      @tags = {}
      @name_stack = []
      @attr_stack = []
      @block_stack = []
      build_tags if respond_to? :build_tags
    end
    
    # Creates a tag definition on a context.
    def tag(name, &block)
      name = name.to_s
      @tags[name] = block || proc { instance_variable_get("@#{name}").to_s }
    end
    
    # Returns the value of a rendered tag. Used internally by Parser#parse.
    def render_tag(tag, attributes = {}, &block)
      name = qualified_tag_name(tag.to_s)
      tag_block = @tags[name]
      if tag_block
        stack(name, attributes, block) do
          instance_eval(&tag_block).to_s
        end
      else
        tag_missing(tag, attributes, &block)
      end
    end
    
    # Like method_missing for objects, but fired when a tag is undefined.
    # Override in your own Context to change what happens when a tag is
    # undefined. By default this method raises an UndefinedTagError.
    def tag_missing(tag, attributes, &block)
      raise UndefinedTagError.new(tag)
    end
    
    private
    
      # Returns the attributes for the current tag.
      def attr
        @attr_stack.last
      end
      alias :attributes :attr
    
      # Returns the render block for the current tag.
      def block
        @block_stack.last
      end
      
      # Executes the render block for the current tag and returns the
      # result.
      def work
        block ? block.call : ''
      end
      
      # A convienence method for managing the various parts of the
      # rendering stack.
      def stack(name, attributes, block)
        @name_stack.push name
        @attr_stack.push attributes
        @block_stack.push block
        result = yield
        @block_stack.pop
        @attr_stack.pop
        @name_stack.pop
        result
      end
      
      # Returns a fully qualified tag name based on state of the
      # rendering stack.
      def qualified_tag_name(name)
        names = @name_stack.dup
        while names.size > 0
          try = (names + [name]).join(':')
          return try if @tags.has_key? try 
          names.pop
        end
        name
      end
  end
  
  class Tag # :nodoc:
    def initialize(&b)
      @block = b
    end
      
    def on_parse(&b)
      @block = b
    end
    
    def to_s
      @block.call(self)
    end
  end

  class ContainerTag < Tag # :nodoc:
    attr_accessor :name, :attributes, :contents
    
    def initialize(name = "", attributes = {}, contents = [], &b)
      @name, @attributes, @contents = name, attributes, contents
      super(&b)
    end
  end
  
  #
  # The Radius parser. Initialize a parser with the Context object that defines
  # how tags should be expanded.
  #
  class Parser
    # The Context object used to expand template tags.
    attr_accessor :context
    
    # Creates a new parser object initialized with a Context.
    def initialize(context = Context.new)
      @context = context
    end

    # Parse string for tags, expand them, and return the result.
    def parse(string)
      @stack = [ContainerTag.new { |t| t.contents.to_s }]
      pre_parse(string)
      @stack.last.to_s
    end
    
    def pre_parse(text) # :nodoc:
      re = %r{<#{@context.prefix}:([\w:]+?)(?:\s+?([^/>]*?)|)>|</#{@context.prefix}:([\w:]+?)\s*?>}
      if md = re.match(text)
        start_tag, attr, end_tag = $1, $2, $3
        @stack.last.contents << Tag.new { parse_individual(md.pre_match) }
        remaining = md.post_match
        if start_tag
          parse_start_tag(start_tag, attr, remaining)
        else
          parse_end_tag(end_tag, remaining)
        end
      else
        if @stack.length == 1
          @stack.last.contents << Tag.new { parse_individual(text) }
        else
          raise MissingEndTagError.new(@stack.last.name)
        end
      end
    end
    
    def parse_start_tag(start_tag, attr, remaining) # :nodoc:
      @stack.push(ContainerTag.new(start_tag, parse_attributes(attr)))
      pre_parse(remaining)
    end

    def parse_end_tag(end_tag, remaining) # :nodoc:
      popped = @stack.pop
      if popped.name == end_tag
        popped.on_parse { |t| @context.render_tag(popped.name, popped.attributes) { t.contents.to_s } }
        tag = @stack.last
        tag.contents << popped
        pre_parse(remaining)
      else
        raise MissingEndTagError.new(popped.name)
      end
    end
    
    def parse_individual(text) # :nodoc:
      re = /<#{@context.prefix}:([\w:]+?)\s+?(.*?)\s*?\/>/
      if md = re.match(text)
        attr = parse_attributes($2)
        replace = @context.render_tag($1, attr)
        md.pre_match + replace + parse_individual(md.post_match)
      else
        text || ''
      end
    end
    
    def parse_attributes(text) # :nodoc:
      attr = {}
      re = /(\w+?)\s*=\s*('|")(.*?)\2/
      while md = re.match(text)
        attr[$1] = $3
        text = md.post_match
      end
      attr
    end
  end
end