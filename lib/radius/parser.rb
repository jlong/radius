module Radius
  #
  # The Radius parser. Initialize a parser with a Context object that
  # defines how tags should be expanded. See the QUICKSTART[link:files/QUICKSTART.html]
  # for a detailed explaination of its usage.
  #
  class Parser
    # The Context object used to expand template tags.
    attr_accessor :context
    
    # The string that prefixes all tags that are expanded by a parser
    # (the part in the tag name before the first colon).
    attr_accessor :tag_prefix

    # The class that performs tokenization of the input string
    attr_accessor :scanner
  
    # Creates a new parser object initialized with a Context.
    def initialize(context = Context.new, options = {})
      context, options = normalize_initialization_params(context, options)
      @context = context ? context.dup : Context.new
      @tag_prefix = options[:tag_prefix] || 'radius'
      @scanner = options[:scanner] || default_scanner
      @stack = nil # Pre-initialize stack
    end
    
    # Parses string for tags, expands them, and returns the result.
    def parse(string)
      @stack = [create_root_container]
      process_tokens(scanner.operate(tag_prefix, string))
      @stack.last.to_s
    end
    
    private

    def normalize_initialization_params(context, options)
      return [context['context'] || context[:context], context] if context.is_a?(Hash) && options.empty?
      [context, Utility.symbolize_keys(options)]
    end

    def create_root_container
      ParseContainerTag.new { |t| Utility.array_to_s(t.contents) }
    end

    def process_tokens(tokens)
      tokens.each { |token| process_token(token) }
      validate_final_stack
    end

    def process_token(token)
      return @stack.last.contents << token if token.is_a?(String)

      case token[:flavor]
      when :open    then handle_open_tag(token)
      when :self    then handle_self_tag(token)
      when :close   then handle_close_tag(token)
      when :tasteless then raise TastelessTagError.new(token, @stack)
      else raise UndefinedFlavorError.new(token, @stack)
      end
    end

    def handle_open_tag(token)
      @stack.push(ParseContainerTag.new(token[:name], token[:attrs]))
    end

    def handle_self_tag(token)
      @stack.last.contents << ParseTag.new { @context.render_tag(token[:name], token[:attrs]) }
    end

    def handle_close_tag(token)
      popped = @stack.pop
      validate_tag_match(popped, token[:name])
      wrap_and_push_tag(popped)
    end

    def validate_tag_match(popped, name)
      raise WrongEndTagError.new(popped.name, name, @stack) if popped.name != name
    end

    def wrap_and_push_tag(tag)
      tag.on_parse { |b| @context.render_tag(tag.name, tag.attributes) { Utility.array_to_s(b.contents) } }
      @stack.last.contents << tag
    end

    def validate_final_stack
      raise MissingEndTagError.new(@stack.last.name, @stack) if @stack.length != 1
    end

    def default_scanner
      if RUBY_PLATFORM == 'java'
        load_java_scanner
      else
        Radius::Scanner.new
      end
    end

    def load_java_scanner
      if Gem::Version.new(JRUBY_VERSION) >= Gem::Version.new('9.3')
        require 'jruby'
      else
        require 'java'
      end
      require 'radius/parser/java_scanner.jar'
      ::Radius.send(:include_package, 'radius.parser')
      Radius::JavaScanner.new(JRuby.runtime)
    end
  end
end
