
// line 1 "JavaScanner.rl"

// line 101 "JavaScanner.rl"


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
    // Validate both prefix and name
    if ((prefix == null || prefix.trim().isEmpty()) && 
        (name == null || name.trim().isEmpty())) {
        pass_through("<");
        return;
    }
    
    if (name == null || name.trim().isEmpty()) {
        pass_through("<" + prefix + ":");
        return;
    }

    RubyHash tag = RubyHash.newHash(runtime);
    tag.op_aset(
      runtime.getCurrentContext(),
      RubySymbol.newSymbol(runtime, "prefix"),
      RubyString.newString(runtime, prefix != null ? prefix : "")
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

  
// line 77 "JavaScanner.java"
private static byte[] init__parser_actions_0()
{
	return new byte [] {
	    0,    1,    0,    1,    3,    1,    4,    1,    5,    1,    6,    1,
	    7,    1,    8,    1,    9,    1,   10,    1,   14,    1,   15,    1,
	   19,    1,   21,    1,   22,    1,   23,    2,    1,    2,    2,    5,
	    6,    2,    6,    7,    2,    9,    5,    2,    9,   10,    2,   10,
	    9,    2,   11,   20,    2,   12,   20,    2,   13,   20,    2,   16,
	   17,    2,   16,   18,    3,    5,    6,    7,    3,    9,    5,    6,
	    3,   16,    6,   17,    4,    9,    5,    6,    7,    4,   16,    5,
	    6,   17,    5,   16,    9,    5,    6,   17
	};
}

private static final byte _parser_actions[] = init__parser_actions_0();


private static short[] init__parser_key_offsets_0()
{
	return new short [] {
	    0,    0,   11,   21,   35,   48,   62,   66,   71,   73,   75,   88,
	  101,  102,  104,  119,  134,  150,  156,  162,  177,  180,  183,  186,
	  201,  203,  205,  220,  236,  242,  248,  251,  254,  270,  286,  303,
	  310,  316,  332,  336,  352,  367,  370,  372,  382,  392,  403,  413,
	  428,  432,  442,  442,  443,  452,  452,  452,  454,  456,  459,  462,
	  464,  466
	};
}

private static final short _parser_key_offsets[] = init__parser_key_offsets_0();


private static char[] init__parser_trans_keys_0()
{
	return new char [] {
	   58,   63,   95,   45,   46,   48,   57,   65,   90,   97,  122,   63,
	   95,   45,   46,   48,   57,   65,   90,   97,  122,   32,   47,   58,
	   62,   63,   95,    9,   13,   45,   57,   65,   90,   97,  122,   32,
	   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,
	   32,   61,   63,   95,    9,   13,   45,   46,   48,   58,   65,   90,
	   97,  122,   32,   61,    9,   13,   32,   34,   39,    9,   13,   34,
	   92,   34,   92,   32,   47,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   47,   62,   63,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   62,   34,   92,   32,   34,   47,   62,
	   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,
	   34,   47,   62,   63,   92,   95,    9,   13,   45,   58,   65,   90,
	   97,  122,   32,   34,   61,   63,   92,   95,    9,   13,   45,   46,
	   48,   58,   65,   90,   97,  122,   32,   34,   61,   92,    9,   13,
	   32,   34,   39,   92,    9,   13,   32,   34,   47,   62,   63,   92,
	   95,    9,   13,   45,   58,   65,   90,   97,  122,   34,   62,   92,
	   34,   39,   92,   34,   39,   92,   32,   39,   47,   62,   63,   92,
	   95,    9,   13,   45,   58,   65,   90,   97,  122,   39,   92,   39,
	   92,   32,   39,   47,   62,   63,   92,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   39,   61,   63,   92,   95,    9,   13,
	   45,   46,   48,   58,   65,   90,   97,  122,   32,   39,   61,   92,
	    9,   13,   32,   34,   39,   92,    9,   13,   34,   39,   92,   34,
	   39,   92,   32,   34,   39,   47,   62,   63,   92,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   32,   34,   39,   47,   62,   63,
	   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   34,
	   39,   61,   63,   92,   95,    9,   13,   45,   46,   48,   58,   65,
	   90,   97,  122,   32,   34,   39,   61,   92,    9,   13,   32,   34,
	   39,   92,    9,   13,   32,   34,   39,   47,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   34,   39,   62,   92,
	   32,   34,   39,   47,   62,   63,   92,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   39,   47,   62,   63,   92,   95,    9,
	   13,   45,   58,   65,   90,   97,  122,   39,   62,   92,   39,   92,
	   63,   95,   45,   46,   48,   57,   65,   90,   97,  122,   63,   95,
	   45,   46,   48,   57,   65,   90,   97,  122,   58,   63,   95,   45,
	   46,   48,   57,   65,   90,   97,  122,   63,   95,   45,   46,   48,
	   57,   65,   90,   97,  122,   32,   58,   62,   63,   95,    9,   13,
	   45,   46,   48,   57,   65,   90,   97,  122,   32,   62,    9,   13,
	   63,   95,   45,   46,   48,   57,   65,   90,   97,  122,   60,   47,
	   63,   95,   45,   57,   65,   90,   97,  122,   34,   92,   34,   92,
	   34,   39,   92,   34,   39,   92,   39,   92,   39,   92,    0
	};
}

private static final char _parser_trans_keys[] = init__parser_trans_keys_0();


private static byte[] init__parser_single_lengths_0()
{
	return new byte [] {
	    0,    3,    2,    6,    5,    4,    2,    3,    2,    2,    5,    5,
	    1,    2,    7,    7,    6,    4,    4,    7,    3,    3,    3,    7,
	    2,    2,    7,    6,    4,    4,    3,    3,    8,    8,    7,    5,
	    4,    8,    4,    8,    7,    3,    2,    2,    2,    3,    2,    5,
	    2,    2,    0,    1,    3,    0,    0,    2,    2,    3,    3,    2,
	    2,    0
	};
}

private static final byte _parser_single_lengths[] = init__parser_single_lengths_0();


private static byte[] init__parser_range_lengths_0()
{
	return new byte [] {
	    0,    4,    4,    4,    4,    5,    1,    1,    0,    0,    4,    4,
	    0,    0,    4,    4,    5,    1,    1,    4,    0,    0,    0,    4,
	    0,    0,    4,    5,    1,    1,    0,    0,    4,    4,    5,    1,
	    1,    4,    0,    4,    4,    0,    0,    4,    4,    4,    4,    5,
	    1,    4,    0,    0,    3,    0,    0,    0,    0,    0,    0,    0,
	    0,    0
	};
}

private static final byte _parser_range_lengths[] = init__parser_range_lengths_0();


private static short[] init__parser_index_offsets_0()
{
	return new short [] {
	    0,    0,    8,   15,   26,   36,   46,   50,   55,   58,   61,   71,
	   81,   83,   86,   98,  110,  122,  128,  134,  146,  150,  154,  158,
	  170,  173,  176,  188,  200,  206,  212,  216,  220,  233,  246,  259,
	  266,  272,  285,  290,  303,  315,  319,  322,  329,  336,  344,  351,
	  362,  366,  373,  374,  376,  383,  384,  385,  388,  391,  395,  399,
	  402,  405
	};
}

private static final short _parser_index_offsets[] = init__parser_index_offsets_0();


private static byte[] init__parser_trans_targs_0()
{
	return new byte [] {
	    2,    1,    1,    1,    1,    1,    1,   51,    3,    3,    3,    3,
	    3,    3,   51,    4,   12,   43,   54,    3,    3,    4,    3,    3,
	    3,   51,    4,   12,   54,    5,    5,    4,    5,    5,    5,   51,
	    6,    7,    5,    5,    6,    5,    5,    5,    5,   51,    6,    7,
	    6,   51,    7,    8,   42,    7,   51,   10,   13,    9,   10,   13,
	    9,   11,   12,   54,    5,    5,   11,    5,    5,    5,   51,   11,
	   12,   54,    5,    5,   11,    5,    5,    5,   51,   53,   51,   14,
	   13,    9,   15,   10,   20,   56,   16,   13,   16,   15,   16,   16,
	   16,    9,   15,   10,   20,   56,   16,   13,   16,   15,   16,   16,
	   16,    9,   17,   10,   18,   16,   13,   16,   17,   16,   16,   16,
	   16,    9,   17,   10,   18,   13,   17,    9,   18,   19,   21,   13,
	   18,    9,   15,   10,   20,   56,   16,   13,   16,   15,   16,   16,
	   16,    9,   10,   55,   13,    9,   23,   14,   31,   22,   23,   14,
	   31,   22,   26,   10,   41,   60,   27,   25,   27,   26,   27,   27,
	   27,   24,   10,   25,   24,   23,   25,   24,   26,   10,   41,   60,
	   27,   25,   27,   26,   27,   27,   27,   24,   28,   10,   29,   27,
	   25,   27,   28,   27,   27,   27,   27,   24,   28,   10,   29,   25,
	   28,   24,   29,   30,   40,   25,   29,   24,   23,   14,   31,   22,
	   32,   32,   31,   22,   33,   23,   14,   38,   58,   34,   31,   34,
	   33,   34,   34,   34,   22,   33,   23,   14,   38,   58,   34,   31,
	   34,   33,   34,   34,   34,   22,   35,   23,   14,   36,   34,   31,
	   34,   35,   34,   34,   34,   34,   22,   35,   23,   14,   36,   31,
	   35,   22,   36,   37,   39,   31,   36,   22,   33,   23,   14,   38,
	   58,   34,   31,   34,   33,   34,   34,   34,   22,   23,   14,   57,
	   31,   22,   33,   23,   14,   38,   58,   34,   31,   34,   33,   34,
	   34,   34,   22,   26,   10,   41,   60,   27,   25,   27,   26,   27,
	   27,   27,   24,   10,   59,   25,   24,   10,   25,   24,    3,    3,
	    3,    3,    3,    3,   51,   45,   45,   45,   45,   45,   45,   51,
	   46,   45,   45,   45,   45,   45,   45,   51,   47,   47,   47,   47,
	   47,   47,   51,   48,   49,   61,   47,   47,   48,   47,   47,   47,
	   47,   51,   48,   61,   48,   51,   47,   47,   47,   47,   47,   47,
	   51,    0,   52,   51,   44,    1,    1,    1,    1,    1,   51,   51,
	   51,   10,   13,    9,   10,   13,    9,   23,   14,   31,   22,   23,
	   14,   31,   22,   10,   25,   24,   10,   25,   24,   51,   51,   51,
	   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
	   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
	   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
	   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
	   51,   51,   51,   51,   51,   51,   51,   51,   51,    0
	};
}

private static final byte _parser_trans_targs[] = init__parser_trans_targs_0();


private static byte[] init__parser_trans_actions_0()
{
	return new byte [] {
	   31,    0,    0,    0,    0,    0,    0,   27,    3,    3,    3,    3,
	    3,    3,   27,    5,    5,    0,    5,    0,    0,    5,    0,    0,
	    0,   27,    0,    0,    0,   11,   11,    0,   11,   11,   11,   27,
	   13,   13,    0,    0,   13,    0,    0,    0,    0,   29,    0,    0,
	    0,   29,    0,    0,    0,    0,   29,   43,   15,   15,   17,    0,
	    0,    7,   34,   34,   64,   64,    7,   64,   64,   64,   29,    0,
	    9,    9,   37,   37,    0,   37,   37,   37,   29,    0,   29,   17,
	    0,    0,    7,   17,   34,   81,   64,    0,   64,    7,   64,   64,
	   64,    0,    0,   17,    9,   72,   37,    0,   37,    0,   37,   37,
	   37,    0,   13,   17,   13,    0,    0,    0,   13,    0,    0,    0,
	    0,    0,    0,   17,    0,    0,    0,    0,    0,   17,    0,    0,
	    0,    0,   40,   43,   68,   86,   76,   15,   76,   40,   76,   76,
	   76,   15,   17,   58,    0,    0,   46,   43,   15,   15,   17,   17,
	    0,    0,    7,   17,   34,   81,   64,    0,   64,    7,   64,   64,
	   64,    0,   17,    0,    0,   17,    0,    0,    0,   17,    9,   72,
	   37,    0,   37,    0,   37,   37,   37,    0,   13,   17,   13,    0,
	    0,    0,   13,    0,    0,    0,    0,    0,    0,   17,    0,    0,
	    0,    0,    0,    0,   17,    0,    0,    0,   43,   43,   15,   15,
	   17,   17,    0,    0,    7,   17,   17,   34,   81,   64,    0,   64,
	    7,   64,   64,   64,    0,    0,   17,   17,    9,   72,   37,    0,
	   37,    0,   37,   37,   37,    0,   13,   17,   17,   13,    0,    0,
	    0,   13,    0,    0,    0,    0,    0,    0,   17,   17,    0,    0,
	    0,    0,    0,   17,   17,    0,    0,    0,   40,   43,   43,   68,
	   86,   76,   15,   76,   40,   76,   76,   76,   15,   17,   17,   58,
	    0,    0,   40,   46,   43,   68,   86,   76,   15,   76,   40,   76,
	   76,   76,   15,   40,   43,   68,   86,   76,   15,   76,   40,   76,
	   76,   76,   15,   17,   58,    0,    0,   43,   15,   15,    0,    0,
	    0,    0,    0,    0,   27,    1,    1,    1,    1,    1,    1,   27,
	   31,    0,    0,    0,    0,    0,    0,   27,    3,    3,    3,    3,
	    3,    3,   27,    5,    0,    5,    0,    0,    5,    0,    0,    0,
	    0,   27,    0,    0,    0,   27,    0,    0,    0,    0,    0,    0,
	   27,    0,   61,   23,    0,    1,    1,    1,    1,    1,   25,   52,
	   49,   17,    0,    0,   17,    0,    0,   17,   17,    0,    0,   17,
	   17,    0,    0,   17,    0,    0,   17,    0,    0,   55,   27,   27,
	   27,   27,   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,
	   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,
	   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,   29,
	   29,   29,   29,   29,   27,   27,   27,   27,   27,   27,   27,   25,
	   52,   49,   52,   49,   52,   49,   52,   49,   55,    0
	};
}

private static final byte _parser_trans_actions[] = init__parser_trans_actions_0();


private static byte[] init__parser_to_state_actions_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,   19,   19,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0
	};
}

private static final byte _parser_to_state_actions[] = init__parser_to_state_actions_0();


private static byte[] init__parser_from_state_actions_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,   21,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0
	};
}

private static final byte _parser_from_state_actions[] = init__parser_from_state_actions_0();


private static short[] init__parser_eof_trans_0()
{
	return new short [] {
	    0,  455,  455,  455,  455,  448,  448,  448,  448,  448,  448,  448,
	  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,
	  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,  448,
	  448,  448,  448,  448,  448,  448,  448,  455,  455,  455,  455,  455,
	  455,  455,    0,    0,  456,  463,  464,  463,  464,  463,  464,  463,
	  464,  465
	};
}

private static final short _parser_eof_trans[] = init__parser_eof_trans_0();


static final int parser_start = 51;
static final int parser_first_final = 51;
static final int parser_error = 0;

static final int parser_en_Closeout = 50;
static final int parser_en_main = 51;


// line 172 "JavaScanner.rl"

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

    
// line 385 "JavaScanner.java"
	{
	cs = parser_start;
	ts = -1;
	te = -1;
	act = 0;
	}

// line 204 "JavaScanner.rl"
    
// line 395 "JavaScanner.java"
	{
	int _klen;
	int _trans = 0;
	int _acts;
	int _nacts;
	int _keys;
	int _goto_targ = 0;

	_goto: while (true) {
	switch ( _goto_targ ) {
	case 0:
	if ( p == pe ) {
		_goto_targ = 4;
		continue _goto;
	}
	if ( cs == 0 ) {
		_goto_targ = 5;
		continue _goto;
	}
case 1:
	_acts = _parser_from_state_actions[cs];
	_nacts = (int) _parser_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _parser_actions[_acts++] ) {
	case 15:
// line 1 "NONE"
	{ts = p;}
	break;
// line 424 "JavaScanner.java"
		}
	}

	_match: do {
	_keys = _parser_key_offsets[cs];
	_trans = _parser_index_offsets[cs];
	_klen = _parser_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _parser_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _parser_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _parser_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _parser_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _parser_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

case 3:
	cs = _parser_trans_targs[_trans];

	if ( _parser_trans_actions[_trans] != 0 ) {
		_acts = _parser_trans_actions[_trans];
		_nacts = (int) _parser_actions[_acts++];
		while ( _nacts-- > 0 )
	{
			switch ( _parser_actions[_acts++] )
			{
	case 0:
// line 4 "JavaScanner.rl"
	{ mark_pfx = p; }
	break;
	case 1:
// line 5 "JavaScanner.rl"
	{
    prefix = String.valueOf(input.substring(mark_pfx, p));
	}
	break;
	case 2:
// line 8 "JavaScanner.rl"
	{
	  if ( !prefix.equals(tag_prefix) ) {
      // Pass through the entire tag markup as text
      pass_through(input.substring(tagstart, p + 1));
      // Reset all state
      prefix = "";
      name = "";
      attributes = RubyHash.newHash(runtime);
      flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
      tagstart = p + 1;
      {cs = 51; _goto_targ = 2; if (true) continue _goto;}
    }
  }
	break;
	case 3:
// line 22 "JavaScanner.rl"
	{ mark_stg = p; }
	break;
	case 4:
// line 23 "JavaScanner.rl"
	{
    name = String.valueOf(input.substring(mark_stg, p));
    if (name == null || name.trim().isEmpty()) {
      // Pass through the entire tag markup as text
      pass_through(input.substring(tagstart, p + 1));
      // Reset all state
      prefix = "";
      name = "";
      attributes = RubyHash.newHash(runtime);
      flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
      tagstart = p + 1;
      {cs = 51; _goto_targ = 2; if (true) continue _goto;}
    }
	}
	break;
	case 5:
// line 37 "JavaScanner.rl"
	{ mark_attr = p; }
	break;
	case 6:
// line 38 "JavaScanner.rl"
	{
    attributes.op_aset(
      runtime.getCurrentContext(),
      RubyString.newString(runtime, nat),
      RubyString.newString(runtime, vat)
    );
	}
	break;
	case 7:
// line 46 "JavaScanner.rl"
	{ mark_nat = p; }
	break;
	case 8:
// line 47 "JavaScanner.rl"
	{ nat = input.substring(mark_nat, p); }
	break;
	case 9:
// line 48 "JavaScanner.rl"
	{ mark_vat = p; }
	break;
	case 10:
// line 49 "JavaScanner.rl"
	{ vat = input.substring(mark_vat, p); }
	break;
	case 11:
// line 51 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "open".intern()); }
	break;
	case 12:
// line 52 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "self".intern()); }
	break;
	case 13:
// line 53 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "close".intern()); }
	break;
	case 16:
// line 1 "NONE"
	{te = p+1;}
	break;
	case 17:
// line 89 "JavaScanner.rl"
	{act = 1;}
	break;
	case 18:
// line 96 "JavaScanner.rl"
	{act = 2;}
	break;
	case 19:
// line 96 "JavaScanner.rl"
	{te = p+1;{
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }}
	break;
	case 20:
// line 89 "JavaScanner.rl"
	{te = p;p--;{
      tag(prefix, name, attributes, flavor);
	    prefix = "";
	    name = "";
	    attributes = RubyHash.newHash(runtime);
	    flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
	  }}
	break;
	case 21:
// line 96 "JavaScanner.rl"
	{te = p;p--;{
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }}
	break;
	case 22:
// line 96 "JavaScanner.rl"
	{{p = ((te))-1;}{
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }}
	break;
	case 23:
// line 1 "NONE"
	{	switch( act ) {
	case 1:
	{{p = ((te))-1;}
      tag(prefix, name, attributes, flavor);
	    prefix = "";
	    name = "";
	    attributes = RubyHash.newHash(runtime);
	    flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
	  }
	break;
	case 2:
	{{p = ((te))-1;}
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }
	break;
	}
	}
	break;
// line 640 "JavaScanner.java"
			}
		}
	}

case 2:
	_acts = _parser_to_state_actions[cs];
	_nacts = (int) _parser_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _parser_actions[_acts++] ) {
	case 14:
// line 1 "NONE"
	{ts = -1;}
	break;
// line 654 "JavaScanner.java"
		}
	}

	if ( cs == 0 ) {
		_goto_targ = 5;
		continue _goto;
	}
	if ( ++p != pe ) {
		_goto_targ = 1;
		continue _goto;
	}
case 4:
	if ( p == eof )
	{
	if ( _parser_eof_trans[cs] > 0 ) {
		_trans = _parser_eof_trans[cs] - 1;
		_goto_targ = 3;
		continue _goto;
	}
	}

case 5:
	}
	break; }
	}

// line 205 "JavaScanner.rl"

    return rv;
  }
}
