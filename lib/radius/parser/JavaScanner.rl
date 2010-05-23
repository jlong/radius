%%{
	machine parser;
	
	action _prefix { mark_pfx = p; }
	action prefix {
    prefix = input.substring(mark_pfx, p);
	}
  action _check_prefix {
	  if ( !prefix.equals(tag_prefix) ) {
      // have to manually add ':' / Sep
      // pass the text through & reset state
      pass_through(return_value, input.substring(tagstart, p) + ":");
      fgoto main;
    }
  }

	action _starttag { mark_stg = p; }
	action starttag { name = input.substring(mark_stg, p); }
	action _attr { mark_attr = p; }
	action attr {
    attributes.put(nat, vat);
	}
	
	action _nameattr { mark_nat = p; }
	action nameattr { nat = input.substring(mark_nat, p); }
	action _valattr { mark_vat = p; }
	action valattr { vat = input.substring(mark_vat, p); }
	
	action opentag  { flavor = Flavor.OPEN; }
	action selftag  { flavor = Flavor.SELF; }
	action closetag { flavor = Flavor.CLOSE; }
	
	Closeout := empty;
	
	# words
	PrefixChar = [\-A-Za-z0-9._?] ;
	NameChar = [\-A-Za-z0-9._:?] ;
	TagName = NameChar+ >_starttag %starttag;
	Prefix = PrefixChar+ >_prefix %prefix;
  Open = "<";
  Sep = ":" >_check_prefix;
  End = "/";
  Close = ">";
	
	Name = Prefix Sep TagName;
	
	NameAttr = NameChar+ >_nameattr %nameattr;
  Q1Char = ( "\\\'" | [^'] ) ;
  Q1Attr = Q1Char* >_valattr %valattr;
  Q2Char = ( "\\\"" | [^"] ) ;
  Q2Attr = Q2Char* >_valattr %valattr;
 
  Attr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'") space* >_attr %attr;
  Attrs = (space+ Attr* | empty);
  
  CloseTrailer = End Close %selftag;
  OpenTrailer = Close %opentag;
  
  Trailer = (OpenTrailer | CloseTrailer);
  
	OpenOrSelfTag = Name Attrs? Trailer;
	CloseTag = End Name space* Close %closetag;
	
	SomeTag = Open (OpenOrSelfTag | CloseTag);
	
	main := |*
	  SomeTag => {
      tag = new Tag(prefix, name, flavor, attributes, false);
	    prefix = "";
	    name = "";
	    flavor = Flavor.TASTELESS;
	    attributes = new HashMap();
	    return_value.add(tag);
	  };
	  any => {
      pass_through(return_value, input.substring(p, p + 1));
	    tagstart = p + 1;
	  };
	*|;
}%%

package radius.parser;

import java.util.HashMap;
import java.util.LinkedList;

public class JavaScanner {

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

  void pass_through(LinkedList<Tag> rv, String str) {
    if (rv.size() > 0) {
      Tag last = rv.getLast();
      if (last.passthrough) {
        last.name += str;
        return;
      }
    }
    Tag t = new Tag((String)null, str, Flavor.TASTELESS, (HashMap)null, true);
    rv.add(t);
  }

  %% write data;

  public LinkedList<Tag> operate(String tag_prefix, String input) {
    char[] data = input.toCharArray();
    Tag tag;
    String disposable_string;

    String name = "";
    String prefix = "";
    Flavor flavor = Flavor.TASTELESS;

    int tagstart = 0;
    int mark_pfx = 0;
    int mark_stg = 0;
    int mark_attr = 0;
    int mark_nat = 0;
    int mark_vat = 0;

    HashMap attributes = new HashMap();
    String nat = "";
    String vat = "";

    int cs;
    int p = 0;
    int pe = data.length;
    int eof = pe;
    int act;
    int ts;
    int te;

    LinkedList<Tag> return_value = new LinkedList<Tag>();
    char[] remainder = data;

    %% write init;
    %% write exec;

    return return_value;
  }
}
