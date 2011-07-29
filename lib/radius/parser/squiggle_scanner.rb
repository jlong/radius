module Radius  
  class SquiggleScanner
    def operate(prefix, data)
      data = Radius::OrdString.new data
      @nodes = ['']
      
      re = %r{\{\s*([\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)(\/?)\}|\{\/([\w:]+?)\s*\}}
      if md = re.match(data)      
        remainder = ''  
        while md
          start_tag, attributes, self_enclosed, end_tag = $1, $2, $3, $4

          flavor = self_enclosed == '/' ? :self : (start_tag ? :open : :close)
          
          @nodes << md.pre_match
          @nodes << {:prefix=>prefix, :name=>(start_tag || end_tag), :flavor => flavor, :attrs => parse_attributes(attributes)}
          remainder = md.post_match
          md = re.match(md.post_match)
        end  
        @nodes << remainder
      else
        @nodes << data
      end

      return @nodes
    end
    
    private

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