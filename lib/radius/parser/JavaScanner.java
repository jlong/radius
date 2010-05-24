
// line 1 "JavaScanner.rl"

// line 84 "JavaScanner.rl"


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

  
// line 65 "JavaScanner.java"
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
	    0,    0,   11,   21,   34,   47,   61,   65,   70,   72,   74,   87,
	  100,  101,  103,  118,  133,  149,  155,  161,  176,  179,  182,  185,
	  200,  202,  204,  219,  235,  241,  247,  250,  253,  269,  285,  302,
	  309,  315,  331,  335,  351,  366,  369,  371,  381,  392,  402,  416,
	  420,  420,  421,  430,  430,  430,  432,  434,  437,  440,  442,  444
	};
}

private static final short _parser_key_offsets[] = init__parser_key_offsets_0();


private static char[] init__parser_trans_keys_0()
{
	return new char [] {
	   58,   63,   95,   45,   46,   48,   57,   65,   90,   97,  122,   63,
	   95,   45,   46,   48,   58,   65,   90,   97,  122,   32,   47,   62,
	   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   47,
	   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,
	   61,   63,   95,    9,   13,   45,   46,   48,   58,   65,   90,   97,
	  122,   32,   61,    9,   13,   32,   34,   39,    9,   13,   34,   92,
	   34,   92,   32,   47,   62,   63,   95,    9,   13,   45,   58,   65,
	   90,   97,  122,   32,   47,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   62,   34,   92,   32,   34,   47,   62,   63,
	   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   34,
	   47,   62,   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   32,   34,   61,   63,   92,   95,    9,   13,   45,   46,   48,
	   58,   65,   90,   97,  122,   32,   34,   61,   92,    9,   13,   32,
	   34,   39,   92,    9,   13,   32,   34,   47,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   34,   62,   92,   34,
	   39,   92,   34,   39,   92,   32,   39,   47,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   39,   92,   39,   92,
	   32,   39,   47,   62,   63,   92,   95,    9,   13,   45,   58,   65,
	   90,   97,  122,   32,   39,   61,   63,   92,   95,    9,   13,   45,
	   46,   48,   58,   65,   90,   97,  122,   32,   39,   61,   92,    9,
	   13,   32,   34,   39,   92,    9,   13,   34,   39,   92,   34,   39,
	   92,   32,   34,   39,   47,   62,   63,   92,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   32,   34,   39,   47,   62,   63,   92,
	   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   34,   39,
	   61,   63,   92,   95,    9,   13,   45,   46,   48,   58,   65,   90,
	   97,  122,   32,   34,   39,   61,   92,    9,   13,   32,   34,   39,
	   92,    9,   13,   32,   34,   39,   47,   62,   63,   92,   95,    9,
	   13,   45,   58,   65,   90,   97,  122,   34,   39,   62,   92,   32,
	   34,   39,   47,   62,   63,   92,   95,    9,   13,   45,   58,   65,
	   90,   97,  122,   32,   39,   47,   62,   63,   92,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   39,   62,   92,   39,   92,   63,
	   95,   45,   46,   48,   57,   65,   90,   97,  122,   58,   63,   95,
	   45,   46,   48,   57,   65,   90,   97,  122,   63,   95,   45,   46,
	   48,   58,   65,   90,   97,  122,   32,   62,   63,   95,    9,   13,
	   45,   46,   48,   58,   65,   90,   97,  122,   32,   62,    9,   13,
	   60,   47,   63,   95,   45,   57,   65,   90,   97,  122,   34,   92,
	   34,   92,   34,   39,   92,   34,   39,   92,   39,   92,   39,   92,
	    0
	};
}

private static final char _parser_trans_keys[] = init__parser_trans_keys_0();


private static byte[] init__parser_single_lengths_0()
{
	return new byte [] {
	    0,    3,    2,    5,    5,    4,    2,    3,    2,    2,    5,    5,
	    1,    2,    7,    7,    6,    4,    4,    7,    3,    3,    3,    7,
	    2,    2,    7,    6,    4,    4,    3,    3,    8,    8,    7,    5,
	    4,    8,    4,    8,    7,    3,    2,    2,    3,    2,    4,    2,
	    0,    1,    3,    0,    0,    2,    2,    3,    3,    2,    2,    0
	};
}

private static final byte _parser_single_lengths[] = init__parser_single_lengths_0();


private static byte[] init__parser_range_lengths_0()
{
	return new byte [] {
	    0,    4,    4,    4,    4,    5,    1,    1,    0,    0,    4,    4,
	    0,    0,    4,    4,    5,    1,    1,    4,    0,    0,    0,    4,
	    0,    0,    4,    5,    1,    1,    0,    0,    4,    4,    5,    1,
	    1,    4,    0,    4,    4,    0,    0,    4,    4,    4,    5,    1,
	    0,    0,    3,    0,    0,    0,    0,    0,    0,    0,    0,    0
	};
}

private static final byte _parser_range_lengths[] = init__parser_range_lengths_0();


private static short[] init__parser_index_offsets_0()
{
	return new short [] {
	    0,    0,    8,   15,   25,   35,   45,   49,   54,   57,   60,   70,
	   80,   82,   85,   97,  109,  121,  127,  133,  145,  149,  153,  157,
	  169,  172,  175,  187,  199,  205,  211,  215,  219,  232,  245,  258,
	  265,  271,  284,  289,  302,  314,  318,  321,  328,  336,  343,  353,
	  357,  358,  360,  367,  368,  369,  372,  375,  379,  383,  386,  389
	};
}

private static final short _parser_index_offsets[] = init__parser_index_offsets_0();


private static byte[] init__parser_indicies_0()
{
	return new byte [] {
	    2,    1,    1,    1,    1,    1,    1,    0,    3,    3,    3,    3,
	    3,    3,    0,    4,    6,    7,    5,    5,    4,    5,    5,    5,
	    0,    8,   10,   11,    9,    9,    8,    9,    9,    9,    0,   13,
	   15,   14,   14,   13,   14,   14,   14,   14,   12,   16,   17,   16,
	   12,   17,   18,   19,   17,   12,   21,   22,   20,   24,   25,   23,
	   26,   28,   29,   27,   27,   26,   27,   27,   27,   12,   30,   32,
	   33,   31,   31,   30,   31,   31,   31,   12,   34,   12,   35,   25,
	   23,   36,   24,   38,   39,   37,   25,   37,   36,   37,   37,   37,
	   23,   40,   24,   42,   43,   41,   25,   41,   40,   41,   41,   41,
	   23,   44,   24,   46,   45,   25,   45,   44,   45,   45,   45,   45,
	   23,   47,   24,   48,   25,   47,   23,   48,   49,   50,   25,   48,
	   23,   51,   21,   53,   54,   52,   22,   52,   51,   52,   52,   52,
	   20,   24,   55,   25,   23,   57,   58,   59,   56,   61,   35,   62,
	   60,   64,   24,   66,   67,   65,   68,   65,   64,   65,   65,   65,
	   63,   24,   68,   63,   61,   68,   63,   69,   24,   71,   72,   70,
	   68,   70,   69,   70,   70,   70,   63,   73,   24,   75,   74,   68,
	   74,   73,   74,   74,   74,   74,   63,   76,   24,   77,   68,   76,
	   63,   77,   78,   79,   68,   77,   63,   80,   58,   59,   56,   81,
	   81,   62,   60,   82,   61,   35,   84,   85,   83,   62,   83,   82,
	   83,   83,   83,   60,   86,   61,   35,   88,   89,   87,   62,   87,
	   86,   87,   87,   87,   60,   90,   61,   35,   92,   91,   62,   91,
	   90,   91,   91,   91,   91,   60,   93,   61,   35,   94,   62,   93,
	   60,   94,   95,   96,   62,   94,   60,   97,   80,   58,   99,  100,
	   98,   59,   98,   97,   98,   98,   98,   56,   61,   35,  101,   62,
	   60,   97,   57,   58,   99,  100,   98,   59,   98,   97,   98,   98,
	   98,   56,  103,   21,  105,  106,  104,  107,  104,  103,  104,  104,
	  104,  102,   24,  108,   68,   63,   21,  107,  102,  109,  109,  109,
	  109,  109,  109,    0,  111,  110,  110,  110,  110,  110,  110,    0,
	  112,  112,  112,  112,  112,  112,    0,  113,  115,  114,  114,  113,
	  114,  114,  114,  114,    0,  116,  117,  116,    0,  118,  120,  119,
	  123,  122,  122,  122,  122,  122,  121,  124,  125,   24,   25,   23,
	   24,   25,   23,   61,   35,   62,   60,   61,   35,   62,   60,   24,
	   68,   63,   24,   68,   63,  126,    0
	};
}

private static final byte _parser_indicies[] = init__parser_indicies_0();


private static byte[] init__parser_trans_targs_0()
{
	return new byte [] {
	   49,    1,    2,    3,    4,    3,   12,   52,    4,    5,   12,   52,
	   49,    6,    5,    7,    6,    7,    8,   42,    9,   10,   13,    9,
	   10,   13,   11,    5,   12,   52,   11,    5,   12,   52,   51,   14,
	   15,   16,   20,   54,   15,   16,   20,   54,   17,   16,   18,   17,
	   18,   19,   21,   15,   16,   20,   54,   53,   22,   23,   14,   31,
	   22,   23,   31,   24,   26,   27,   41,   58,   25,   26,   27,   41,
	   58,   28,   27,   29,   28,   29,   30,   40,   23,   32,   33,   34,
	   38,   56,   33,   34,   38,   56,   35,   34,   36,   35,   36,   37,
	   39,   33,   34,   38,   56,   55,   24,   26,   27,   41,   58,   25,
	   57,   44,   44,   45,   46,   47,   46,   59,   47,   59,    0,   49,
	   50,   49,    1,   43,   49,   49,   49
	};
}

private static final byte _parser_trans_targs[] = init__parser_trans_targs_0();


private static byte[] init__parser_trans_actions_0()
{
	return new byte [] {
	   27,    0,   31,    3,    5,    0,    5,    5,    0,   11,    0,    0,
	   29,   13,    0,   13,    0,    0,    0,    0,   15,   43,   15,    0,
	   17,    0,    7,   64,   34,   34,    0,   37,    9,    9,    0,   17,
	    7,   64,   34,   81,    0,   37,    9,   72,   13,    0,   13,    0,
	    0,   17,    0,   40,   76,   68,   86,   58,   15,   46,   43,   15,
	    0,   17,    0,    0,    7,   64,   34,   81,    0,    0,   37,    9,
	   72,   13,    0,   13,    0,    0,    0,   17,   43,   17,    7,   64,
	   34,   81,    0,   37,    9,   72,   13,    0,   13,    0,    0,   17,
	   17,   40,   76,   68,   86,   58,   15,   40,   76,   68,   86,   15,
	   58,    1,    0,   31,    3,    5,    0,    5,    0,    0,    0,   23,
	   61,   25,    1,    0,   52,   49,   55
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
	   19,   19,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
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
	    0,   21,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
	};
}

private static final byte _parser_from_state_actions[] = init__parser_from_state_actions_0();


private static short[] init__parser_eof_trans_0()
{
	return new short [] {
	    0,    1,    1,    1,    1,   13,   13,   13,   13,   13,   13,   13,
	   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
	   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
	   13,   13,   13,   13,   13,   13,   13,    1,    1,    1,    1,    1,
	    0,    0,  122,  125,  126,  125,  126,  125,  126,  125,  126,  127
	};
}

private static final short _parser_eof_trans[] = init__parser_eof_trans_0();


static final int parser_start = 49;
static final int parser_first_final = 49;
static final int parser_error = 0;

static final int parser_en_Closeout = 48;
static final int parser_en_main = 49;


// line 143 "JavaScanner.rl"

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

    
// line 351 "JavaScanner.java"
	{
	cs = parser_start;
	ts = -1;
	te = -1;
	act = 0;
	}

// line 175 "JavaScanner.rl"
    
// line 361 "JavaScanner.java"
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
// line 390 "JavaScanner.java"
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

	_trans = _parser_indicies[_trans];
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
    prefix = input.substring(mark_pfx, p);
	}
	break;
	case 2:
// line 8 "JavaScanner.rl"
	{
	  if ( !prefix.equals(tag_prefix) ) {
      // have to manually add ':' / Sep
      // pass the text through & reset state
      pass_through(input.substring(tagstart, p) + ":");
      prefix = "";
      {cs = 49; _goto_targ = 2; if (true) continue _goto;}
    }
  }
	break;
	case 3:
// line 18 "JavaScanner.rl"
	{ mark_stg = p; }
	break;
	case 4:
// line 19 "JavaScanner.rl"
	{ name = input.substring(mark_stg, p); }
	break;
	case 5:
// line 20 "JavaScanner.rl"
	{ mark_attr = p; }
	break;
	case 6:
// line 21 "JavaScanner.rl"
	{
    attributes.op_aset(
      runtime.getCurrentContext(),
      RubyString.newString(runtime, nat),
      RubyString.newString(runtime, vat)
    );
	}
	break;
	case 7:
// line 29 "JavaScanner.rl"
	{ mark_nat = p; }
	break;
	case 8:
// line 30 "JavaScanner.rl"
	{ nat = input.substring(mark_nat, p); }
	break;
	case 9:
// line 31 "JavaScanner.rl"
	{ mark_vat = p; }
	break;
	case 10:
// line 32 "JavaScanner.rl"
	{ vat = input.substring(mark_vat, p); }
	break;
	case 11:
// line 34 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "open".intern()); }
	break;
	case 12:
// line 35 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "self".intern()); }
	break;
	case 13:
// line 36 "JavaScanner.rl"
	{ flavor = RubySymbol.newSymbol(runtime, "close".intern()); }
	break;
	case 16:
// line 1 "NONE"
	{te = p+1;}
	break;
	case 17:
// line 72 "JavaScanner.rl"
	{act = 1;}
	break;
	case 18:
// line 79 "JavaScanner.rl"
	{act = 2;}
	break;
	case 19:
// line 79 "JavaScanner.rl"
	{te = p+1;{
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }}
	break;
	case 20:
// line 72 "JavaScanner.rl"
	{te = p;p--;{
      tag(prefix, name, attributes, flavor);
	    prefix = "";
	    name = "";
	    attributes = RubyHash.newHash(runtime);
	    flavor = RubySymbol.newSymbol(runtime, "tasteless".intern());
	  }}
	break;
	case 21:
// line 79 "JavaScanner.rl"
	{te = p;p--;{
      pass_through(input.substring(p, p + 1));
	    tagstart = p + 1;
	  }}
	break;
	case 22:
// line 79 "JavaScanner.rl"
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
// line 590 "JavaScanner.java"
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
// line 604 "JavaScanner.java"
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

// line 176 "JavaScanner.rl"

    return rv;
  }
}
