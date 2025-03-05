module Radius  
  class MixedScanner < Radius::Scanner
    
    def scanner_regex(prefix = nil)
      # allow for <prefix:tag></prefix:tag> {prefix:tag}{/prefix:tag} and {tag} style syntax
      %r{<#{prefix}:([\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)(\/?)>|<\/#{prefix}:([\w:]+?)\s*>|\{#{prefix}:([\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)(\/?)\}|\{\/#{prefix}:([\w:]+?)\s*\}|\{\s*([\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)\}}
    end
    
    def operate(prefix, data)
      data = Radius::OrdString.new data
      @nodes = ['']
      
      re = scanner_regex(prefix)
      if md = re.match(data)      
        remainder = ''  
        while md
          start_tag, attributes, self_enclosed, end_tag = $1, $2, $3, $4
  
          flavor = self_enclosed == '/' ? :self : (start_tag ? :open : :close)
  
          # if {prefix:tag}..{/prefix:tag} style syntax
          if $5 or $8
            start_tag, attributes, self_enclosed, end_tag = $5, $6, $7, $8
            flavor = self_enclosed == '/' ? :self : (start_tag ? :open : :close)
          end    
  
          # if {tag} style syntax without prefix and end tags
          if $9
            start_tag = $9
            attributes = $10
            flavor = :self
          end
  
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
  end
end