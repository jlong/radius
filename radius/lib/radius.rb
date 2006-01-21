module Radius
  class ParseError < StandardError; end
  
  class MissingEndTagError < ParseError
    def initialize(tag_name)
      super("end tag not found for start tag `#{tag_name}'")
    end
  end
  
  class Context
    attr_accessor :prefix
    
    def initialize
      @prefix = 'radius'
    end
  end
  
  class Tag
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

  class ContainerTag < Tag
    attr_accessor :name, :attributes, :contents
    
    def initialize(name="", attributes={}, contents = [], &b)
      @name, @attributes, @contents = name, attributes, contents
      super(&b)
    end
  end
    
  class Parser
    def initialize(context = Context.new)
      @context = context
    end

    def parse(text)
      @stack = [ContainerTag.new { |t| t.contents.to_s }]
      pre_parse(text)
      @stack.last.to_s
    end
    
    def pre_parse(text)
      re = %r{<#{@context.prefix}:(\w+?)(?:\s+?([^/>]*?)|)>|</#{@context.prefix}:(\w+?)\s*?>}
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
    
    def parse_start_tag(start_tag, attr, remaining)
      @stack.push(ContainerTag.new(start_tag, parse_attributes(attr)))
      pre_parse(remaining)
    end

    def parse_end_tag(end_tag, remaining)
      popped = @stack.pop
      if popped.name == end_tag
        popped.on_parse { |t| @context.send(popped.name, popped.attributes) { t.contents.to_s } }
        tag = @stack.last
        tag.contents << popped
        pre_parse(remaining)
      else
        raise MissingEndTagError.new(popped.name)
      end
    end
    
    def parse_individual(text)
      re = /<#{@context.prefix}:(\w+?)\s+?(.*?)\s*?\/>/
      if md = re.match(text)
        attr = parse_attributes($2)
        replace = @context.send($1, attr)
        md.pre_match + replace + parse_individual(md.post_match)
      else
        text || ''
      end
    end
    
    def parse_attributes(text)
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