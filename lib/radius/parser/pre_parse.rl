%%{
	machine pre_parse;
	
	action _prefix { mark_pfx = p }
	action prefix { @prefix = data[mark_pfx..p-1] }
	action _starttag { mark_stg = p }
	action starttag { @starttag = data[mark_stg..p-1] }
	action _attr { mark_attr = p }
	action attr {
	  @attrs[@nat] = @vat 
	}
	
	action prematch {
	  @prematch_end = p
	  @prematch = data[0..p] if p > 0
	}
	
	action _nameattr { mark_nat = p }
	action nameattr { @nat = data[mark_nat..p-1] }
	action _valattr { mark_vat = p }
	action valattr { @vat = data[mark_vat..p-1] }
	
	action opentag  { @flavor = :open }
	action selftag  { @flavor = :self }
	action closetag { @flavor = :close }
	
	action stopparse {
	  $stderr.puts "stopping at #{@data[0..p]}"
	  @cursor = p;
	  fbreak;
	}
	
	# words
	NameChar = [\-A-Za-z0-9._:?] ;
	TagName = NameChar* >_starttag %starttag;
	Prefix = NameChar* >_prefix %prefix;
	
	Name = Prefix ":" TagName;
	
	NameAttr = NameChar+ >_nameattr %nameattr;
  Q1Char = ( "\\\'" | [^'] ) ;
  Q1Attr = Q1Char* >_valattr %valattr;
  Q2Char = ( "\\\"" | [^"] ) ;
  Q2Attr = Q2Char* >_valattr %valattr;
 
  Attr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'") space* >_attr %attr;
  Attrs = (space+ Attr* | empty) %{$stderr.puts "left attrs #{@attrs.inspect}"};
  
  CloseTrailer = "/>" >{$stderr.puts "checking close"} %selftag;
  OpenTrailer = ">" >{$stderr.puts "checking open"} %opentag;
  
  Trailer = (OpenTrailer | CloseTrailer)
    >{$stderr.puts "looking for trailer #{@data[p..p+2]}"}
    $err{$stderr.puts "couldn't find trailer #{@data[p-2..p+2]}"};
  
	OpenOrSelfTag = "<" Name Attrs Trailer;
	CloseTag = "</" Name space* ">" %closetag;
	
	PreMatch = (^"<")* %prematch;
	PostMatch = any*;
	
	main := PreMatch (OpenOrSelfTag | CloseTag)? PostMatch %stopparse;
}%%

module Radius
  class Scanner
    attr_reader :prefix, :starttag, :attrs, :flavor, :prematch
    
    def initialize(data)
      @data = data
      @prematch = ''
    	@prefix = nil
    	@starttag = nil
    	@attrs = {}
    	@flavor = :tasteless
    	@cursor = 0
    end
    
    def parse
    	parse_with_stack(@data, [])
    end
    
    def inspect
      "#<Radius::Scanner #{content.inspect} prefix=#{@prefix.inspect} tag=#{@starttag.inspect} flavor=#{@flavor.inspect} cursor=#{@cursor} attrs=#{@attrs.inspect}>"
    end
    
    def content
      @data[@prematch_end..@cursor-1]
    end
    
    def leftover
      @data[@cursor..-1]
    end
    
    private
    def parse_with_stack(data, selstack)
    	buf = ""
    	csel = ""
      stack = []
      eof = data.length
    	%% write data;
    	%% write init;
    	%% write exec;
    	$stderr.puts inspect
    end
  end
end