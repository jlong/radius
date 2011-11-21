module Radius  
  class Scanner
    
    # The regular expression used to find (1) opening and self-enclosed tag names, (2) self-enclosing trailing slash, 
    # (3) attributes and (4) closing tag 
    def scanner_regex(prefix = nil)
      %r{<#{prefix}:([-\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)(\/?)>|<\/#{prefix}:([-\w:]+?)\s*>}
    end
    
    # Parses a given string and returns an array of nodes.
    # The nodes consist of strings and hashes that describe a Radius tag that was found.
    def operate(prefix, data)
      data = Radius::OrdString.new data
      @nodes = ['']
      
      re = scanner_regex(prefix)
      if md = re.match(data)      
        remainder = ''  
        while md
          start_tag, attributes, self_enclosed, end_tag = $1, $2, $3, $4

          flavor = self_enclosed == '/' ? :self : (start_tag ? :open : :close)
          
          # save the part before the current match as a string node
          @nodes << md.pre_match
          
          # save the tag that was found as a tag hash node
          @nodes << {:prefix=>prefix, :name=>(start_tag || end_tag), :flavor => flavor, :attrs => parse_attributes(attributes)}
          
          # remember the part after the current match
          remainder = md.post_match
          
          # see if we find another tag in the remaining string
          md = re.match(md.post_match)
        end  
        
        # add the last remaining string after the last tag that was found as a string node
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