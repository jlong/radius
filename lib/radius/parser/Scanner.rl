%%{
	machine parser;
	
	action _prefix { mark_pfx = p; }
	action prefix {
    disposable_string = input.substring(mark_pfx, p-1);
	  if (disposable_string != prefix) {
      // pass the text through
      return_value.getLast().name += disposable_string;
	    fbreak;
    }
	}
	action _starttag { mark_stg = p; }
	action starttag { starttag = input.substring(mark_stg, p-1); }
	action _attr { mark_attr = p; }
	action attr {
    attributes.put(nat, vat);
	}
	
	action prematch {
	  prematch_end = p;
    if (p > 0) {
      prematch = input.substring(0, p);
    }
	}
	
	action _nameattr { mark_nat = p; }
	action nameattr { nat = input.substring(mark_nat, p-1); }
	action _valattr { mark_vat = p; }
	action valattr { vat = input.substring(mark_vat, p-1); }
	
	action opentag  { flavor = Flavor.OPEN; }
	action selftag  { flavor = Flavor.SELF; }
	action closetag { flavor = Flavor.CLOSE; }
	
	action stopparse {
	  cursor = p;
	  fbreak;
	}
	
	
	Closeout := empty;
	
	# words
	PrefixChar = [\-A-Za-z0-9._?] ;
	NameChar = [\-A-Za-z0-9._:?] ;
	TagName = NameChar+ >_starttag %starttag;
	Prefix = PrefixChar+ >_prefix %prefix;
	
	Name = Prefix ":" TagName;
	
	NameAttr = NameChar+ >_nameattr %nameattr;
  Q1Char = ( "\\\'" | [^'] ) ;
  Q1Attr = Q1Char* >_valattr %valattr;
  Q2Char = ( "\\\"" | [^"] ) ;
  Q2Attr = Q2Char* >_valattr %valattr;
 
  Attr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'") space* >_attr %attr;
  Attrs = (space+ Attr* | empty);
  
  CloseTrailer = "/>" %selftag;
  OpenTrailer = ">" %opentag;
  
  Trailer = (OpenTrailer | CloseTrailer);
  
	OpenOrSelfTag = Name Attrs? Trailer;
	CloseTag = "/" Name space* ">" %closetag;
	
	SomeTag = '<' (OpenOrSelfTag | CloseTag);
	
	main := |*
	  SomeTag => {
      tag = new Tag(prefix, name, flavor, attrs, false);
	    prefix = null;
	    name = "";
	    flavor = Flavor.TASTELESS;
	    attrs = new HashMap();
	    return_value.add(tag);
      fbreak;
	  };
	  any => {
      if (return_value.getLast().passthrough) {
        return_value.getLast().name += input.substring(p, p);
      } else {
        tag = new Tag((String)null, input.substring(p, p+1), Flavor.TASTELESS, (HashMap)null, true);
        return_value.add(tag);
      }
	    tagstart = p;
	  };
	*|;
}%%

package Radius;

import java.util.HashMap;
import java.util.LinkedList;

public class Scanner {

  public enum Flavor { TASTELESS, OPEN, SELF, CLOSE }

  public class Tag {
    public String prefix;
    public String name;
    public Flavor flavor;
    public HashMap attributes;
    public boolean passthrough; // name == stream text, not a radius tag

    public Tag(String prefix, String name, Flavor flavor, HashMap attributes, boolean passthrough) {
      this.prefix = prefix;
      this.name = name;
      this.flavor = flavor;
      this.attributes = attributes;
      this.passthrough = passthrough;
    }
  }

  %% write data;

  public LinkedList<Tag> operate(String prefix, String input) {
    char[] data = input.toCharArray();
    Tag tag;
    String disposable_string;
    String prematch = "";
    String starttag = "";

    String name = "";
    Flavor flavor = Flavor.TASTELESS;
    HashMap attrs = new HashMap();

    int tagstart;
    int mark_pfx = 0;
    int mark_stg = 0;
    int mark_attr = 0;
    int prematch_end;
    int mark_nat = 0;
    int mark_vat = 0;

    HashMap attributes = new HashMap();
    String nat = "";
    String vat = "";
    int cursor = 0;

    int cs;
    int p = 0;
    int pe = data.length;
    int eof = pe;
    int[] stack = new int[32];
    int top;
    int act;
    int ts;
    int te;

    LinkedList<Tag> return_value = new LinkedList<Tag>();
    char[] remainder = data;

/*
    while(remainder.length > 0) {
      p = perform_parse(prefix, remainder)
      remainder = new String(remainder).substring(p).toCharArray();
    }
*/

    %% write init;
    %% write exec;

    return return_value;
  }
}
