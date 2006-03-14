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
      @tag_definitions = {}
      @tag_render_stack = []
      @enumerable_each_items = {}
    end
    
    # Creates a tag definition on a context. Several options are available to you
    # when creating a tag:
    #
    # +expose+::      Specifieds that child tags should be set for each of the methods
    #                 contained in this option. May be either a single symbol or an
    #                 array of symbols.
    # 
    # +for+::         Specifies the name for the instance variable that the main
    #                 tag is in reference to. This is applical when a block is not
    #                 passed to the tag, or when the +expose+ option is also used.
    #
    # +item_tag+::    Specifies the name of the item tag (only applicable when the type
    #                 option is set to 'enumerable').
    #
    # +item_expose+:: Works like +expose+ except that it exposes methods on items
    #                 referenced by tags with a type of 'enumerable'.
    #
    # +type+::        When this option is set to 'enumerable' the following additional
    #                 tags are added as child tags: +each+, <tt>each:item</tt>, +max+, 
    #                 +min+, +size+, +length+, and +count+.
    #
    def define_tag(name, options = {}, &block)
      options = prepare_tag_options(name, options)
      type = options.delete(:type)
      case type.to_s
      when 'enumerable'
        define_enumerable_tag(name, options, &block)
      else
        unless block
          define_ivar_tag(name, options)
        else
          @tag_definitions[name.to_s] = block
          expose_methods_as_tags(name, options)
        end
      end
    end
    
    def define_ivar_tag(name, options) # :nodoc:
      options = prepare_tag_options(name, options)
      define_tag(name, options) do
        if single?
          get_for_object(options[:for]).to_s
        else
          expand
        end
      end
    end
    
    def define_enumerable_tag(name, options, &block) # :nodoc:
      options = prepare_tag_options(name, options)
      
      options[:expose] += ['min', 'max']
      define_tag(name, options, &block)
      
      define_tag("#{name}:size") do
        object = get_for_object(options[:for])
        object.entries.size
      end
      
      define_tag("#{name}:count") do
        render_tag "#{name}:size"
      end
      
      define_tag("#{name}:length") do
        render_tag "#{name}:size"
      end
      
      define_tag("#{name}:each") do
        object = get_for_object(options[:for])
        n = qualified_tag_name(name)
        result = []
        object.each do |item|
          @enumerable_each_items[n] = item
          result << expand
        end 
        result
      end
      
      define_tag(
        "#{name}:each:#{options[:item_tag]}",
        :for => proc { enumerable_item_for(name) },
        :expose => options[:item_expose]
      ) do
        enumerable_item_for(name)
      end
    end
    
    # Returns the value of a rendered tag. Used internally by Parser#parse.
    def render_tag(tag, attributes = {}, &block)
      name = qualified_tag_name(tag.to_s)
      tag_block = @tag_definitions[name]
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
        @tag_render_stack.last[:attr]
      end
      alias :attributes :attr
    
      # Returns the render block for the current tag.
      def block
        @tag_render_stack.last[:block]
      end
      
      # Executes the render block for the current tag and returns the
      # result. Returns and empty string if block is nil.
      def expand
        double? ? block.call : ''
      end
      
      # Returns true if the current tag is a single tag
      def single?
        block.nil?
      end
      
      # Returns true if the current tag is a double tag
      def double?
        not single?
      end
      
      # Returns the current item in the named enumerable loop
      def enumerable_item_for(name)
        n = qualified_tag_name(name)
        @enumerable_each_items[n]
      end
      
      # A convienence method for managing the various parts of the
      # tag render stack.
      def stack(name, attributes, block)
        @tag_render_stack.push(:name => name, :attr => attributes, :block => block)
        result = yield
        @tag_render_stack.pop
        result
      end
      
      # Returns a fully qualified tag name based on state of the
      # tag render stack.
      def qualified_tag_name(name)
        names = @tag_render_stack.collect { |item| item[:name] }
        while names.size > 0
          try = (names + [name]).join(':')
          return try if @tag_definitions.has_key? try 
          names.pop
        end
        name
      end
      
      # Helper method for normalizing options pased to tag definition methods
      def prepare_tag_options(name, options)
        options = Util.symbolize_keys(options)
        options[:for] = (options.has_key?(:for) ? options[:for] : name)
        options[:for] = options[:for].to_s unless options[:for].kind_of? Proc
        options[:expose] = [*options[:expose]].compact.map { |m| m.to_s }
        options[:item_tag] = (options.has_key?(:item_tag) ? options[:item_tag] : 'item').to_s
        options
      end
      
      # Helper method for exposing the methods of an object as tags
      def expose_methods_as_tags(name, options)
        options = prepare_tag_options(name, options)
        options[:expose].each do |method|
          define_tag("#{name}:#{method}") do
            object = get_for_object(options[:for])
            object.send(method).to_s
          end
        end
      end
      
      # Helper method to return for option object.
      def get_for_object(for_option)
        case for_option
        when Proc
          instance_eval &for_option
        else
          instance_variable_get "@#{for_option}"
        end
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
  
  module Util # :nodoc:
    def self.symbolize_keys(hash)
      new_hash = {}
      hash.keys.each do |k|
        new_hash[k.to_s.intern] = hash[k]
      end
      new_hash
    end
  end
  
end