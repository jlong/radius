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
      pass_through(input.substring(tagstart, p) + ":");
      prefix = "";
      fgoto main;
    }
  }

	action _starttag { mark_stg = p; }
	action starttag { name = input.substring(mark_stg, p); }
	action _attr { mark_attr = p; }
	action attr {
    attributes.op_aset(
      runtime.getCurrentContext(),
      RubyString.newString(runtime, nat),
      RubyString.newString(runtime, vat)
    );
	}
	
	action _nameattr { mark_nat = p; }
	action nameattr { nat = input.substring(mark_nat, p); }
	action _valattr { mark_vat = p; }
	action valattr { vat = input.substring(mark_vat, p); }
	
	action opentag  { flavor = RubySymbol.newSymbol(runtime, "open".intern()); }
	action selftag  { flavor = RubySymbol.newSymbol(runtime, "self".intern()); }
	action closetag { flavor = RubySymbol.newSymbol(runtime, "close".intern()); }
	
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
      tag(prefix, name, attributes, flavor);
	    prefix = "";
	    name = "";
	    attributes = RubyHash.newHash(runtime);
	    flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
	  };
	  any => {
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  };
	*|;
}%%

package radius.parser;

import java.util.HashMap;
import java.util.LinkedList;
import org.jruby.Ruby; // runtime
import org.jruby.RubyObject;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.RubyArray;
import org.jruby.RubyString;
import org.jruby.RubyHash;
import org.jruby.RubySymbol;

public class JavaScanner {

  Ruby runtime = null;
  RubyArray rv = null;

  void pass_through(String str) {
    RubyObject last = ((RubyObject)rv.last());
    if ( rv.size() > 0 &&  last != null && (last instanceof RubyString) ){
      // XXX concat changes for ruby 1.9
      ((RubyString) last).concat(RubyString.newString(runtime, str));
    } else {
      rv.append(RubyString.newString(runtime, str));
    }
  }

  void tag(String prefix, String name, RubyHash attr, RubySymbol flavor) {
    RubyHash tag = RubyHash.newHash(runtime);
    tag.op_aset(
      runtime.getCurrentContext(),
      RubySymbol.newSymbol(runtime, "prefix"),
      RubyString.newString(runtime, prefix)
    );
    tag.op_aset(
      runtime.getCurrentContext(),
      RubySymbol.newSymbol(runtime, "name"),
      RubyString.newString(runtime, name)
    );
    tag.op_aset(
      runtime.getCurrentContext(),
      RubySymbol.newSymbol(runtime, "attrs"),
      attr
    );
    tag.op_aset(
      runtime.getCurrentContext(),
      RubySymbol.newSymbol(runtime, "flavor"),
      flavor
    );
    rv.append(tag);
  }

  public JavaScanner(Ruby runtime) {
    this.runtime = runtime;
  }

  %% write data;

  public RubyArray operate(String tag_prefix, String input) {
    char[] data = input.toCharArray();
    String disposable_string;

    String name = "";
    String prefix = "";
    RubySymbol flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
    RubyHash attributes = RubyHash.newHash(runtime);

    int tagstart = 0;
    int mark_pfx = 0;
    int mark_stg = 0;
    int mark_attr = 0;
    int mark_nat = 0;
    int mark_vat = 0;

    String nat = "";
    String vat = "";

    int cs;
    int p = 0;
    int pe = data.length;
    int eof = pe;
    int act;
    int ts;
    int te;

    rv = RubyArray.newArray(runtime);
    char[] remainder = data;

    %% write init;
    %% write exec;

    return rv;
  }
}
