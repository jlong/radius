module Radius  
  class SquiggleScanner < Scanner
    
    # The regular expression used to find (1) opening and self-enclosed tag names, (2) self-enclosing trailing slash, 
    # (3) attributes and (4) closing tag
    def scanner_regex(prefix = nil)
      %r{\{\s*([\w:]+?)(\s+(?:\w+\s*=\s*(?:"[^"]*?"|'[^']*?')\s*)*|)(\/?)\}|\{\/([\w:]+?)\s*\}}
    end
    
  end
end