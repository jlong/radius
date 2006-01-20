module Radius
	class Context; end
	
	class Data
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

	class DoubleTag < Data
		attr_accessor :name, :attributes, :contents
		def initialize(name="", attributes={}, contents = [], &b)
			super(&b)
			@name, @attributes, @contents = name, attributes, contents
		end
	end
		
	class Parser
		def initialize(options = {})
			@options = { :pre => "pre" }.update(options)
			@options[:context] = Context.new unless @options[:context]
			@context = @options[:context]
		end

		def parse(text)
			@stack = [DoubleTag.new { |t| t.contents.to_s }]
			pre_parse(text)
			@stack.last.to_s
		end
		
		def pre_parse(text)
			re = %r{<#{@options[:pre]}:(\w+?)(?:\s+?([^/>]*?)|)>|</#{@options[:pre]}:(\w+?)\s*?>}
			if md = re.match(text)
				start_tag, attr, end_tag = $1, $2, $3
				@stack.last.contents << Data.new { parse_individual(md.pre_match) }
				remaining = md.post_match
				if start_tag
					parse_start_tag(start_tag, attr, remaining)
				else
					parse_end_tag(end_tag, remaining)
				end
			else
				if @stack.length == 1
					@stack.last.contents << Data.new { parse_individual(text) }
				else
					raise "parse error"
				end
			end
		end
		
		def parse_start_tag(start_tag, attr, remaining)
			@stack.push(DoubleTag.new(start_tag, parse_attributes(attr)))
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
				raise "parse error: start tag not found for #{end_tag}"
			end
		end
		
		def parse_individual(text)
			re = /<#{@options[:pre]}:(\w+?)\s+?(.*?)\s*?\/>/
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