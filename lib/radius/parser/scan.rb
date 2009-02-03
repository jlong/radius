# line 1 "scan.rl"
# line 82 "scan.rl"


module Radius
  class Scanner
    def self.operate(prefix, data)
      buf = ""
      csel = ""
      @prematch = ''
      @starttag = nil
      @attrs = {}
      @flavor = :tasteless
      @cursor = 0
      @tagstart = 0
      @nodes = ['']
      remainder = data.dup

      until remainder.length == 0
        p = perform_parse(prefix, remainder)
        remainder = remainder[p..-1]
      end

      return @nodes
    end
    
    private
    def self.perform_parse(prefix, data)
      stack = []
      p = 0
      ts = 0
      te = 0
      act = 0
      eof = data.length
      
      @prefix = prefix
      
# line 39 "scan.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9, 1, 13, 1, 
	14, 1, 18, 1, 20, 1, 21, 1, 
	22, 2, 0, 1, 2, 2, 3, 2, 
	4, 5, 2, 5, 6, 2, 8, 4, 
	2, 8, 9, 2, 9, 8, 2, 10, 
	19, 2, 11, 19, 2, 12, 19, 2, 
	15, 16, 2, 15, 17, 3, 4, 5, 
	6, 3, 8, 4, 5, 3, 15, 5, 
	16, 4, 8, 4, 5, 6, 4, 15, 
	4, 5, 16, 5, 15, 8, 4, 5, 
	16
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 11, 24, 37, 51, 55, 60, 
	62, 64, 77, 90, 91, 93, 108, 123, 
	139, 145, 151, 166, 169, 172, 175, 190, 
	192, 194, 209, 225, 231, 237, 240, 243, 
	259, 275, 292, 299, 305, 321, 325, 341, 
	356, 359, 361, 374, 385, 396, 410, 414, 
	428, 428, 429, 439, 439, 439, 441, 443, 
	446, 449, 451, 453
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	58, 63, 95, 45, 46, 48, 57, 65, 
	90, 97, 122, 32, 47, 62, 63, 95, 
	9, 13, 45, 58, 65, 90, 97, 122, 
	32, 47, 62, 63, 95, 9, 13, 45, 
	58, 65, 90, 97, 122, 32, 61, 63, 
	95, 9, 13, 45, 46, 48, 58, 65, 
	90, 97, 122, 32, 61, 9, 13, 32, 
	34, 39, 9, 13, 34, 92, 34, 92, 
	32, 47, 62, 63, 95, 9, 13, 45, 
	58, 65, 90, 97, 122, 32, 47, 62, 
	63, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 62, 34, 92, 32, 34, 47, 
	62, 63, 92, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 32, 34, 47, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 32, 34, 61, 63, 92, 
	95, 9, 13, 45, 46, 48, 58, 65, 
	90, 97, 122, 32, 34, 61, 92, 9, 
	13, 32, 34, 39, 92, 9, 13, 32, 
	34, 47, 62, 63, 92, 95, 9, 13, 
	45, 58, 65, 90, 97, 122, 34, 62, 
	92, 34, 39, 92, 34, 39, 92, 32, 
	39, 47, 62, 63, 92, 95, 9, 13, 
	45, 58, 65, 90, 97, 122, 39, 92, 
	39, 92, 32, 39, 47, 62, 63, 92, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 32, 39, 61, 63, 92, 95, 9, 
	13, 45, 46, 48, 58, 65, 90, 97, 
	122, 32, 39, 61, 92, 9, 13, 32, 
	34, 39, 92, 9, 13, 34, 39, 92, 
	34, 39, 92, 32, 34, 39, 47, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 32, 34, 39, 47, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 32, 34, 39, 61, 63, 
	92, 95, 9, 13, 45, 46, 48, 58, 
	65, 90, 97, 122, 32, 34, 39, 61, 
	92, 9, 13, 32, 34, 39, 92, 9, 
	13, 32, 34, 39, 47, 62, 63, 92, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 34, 39, 62, 92, 32, 34, 39, 
	47, 62, 63, 92, 95, 9, 13, 45, 
	58, 65, 90, 97, 122, 32, 39, 47, 
	62, 63, 92, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 39, 62, 92, 39, 
	92, 32, 47, 62, 63, 95, 9, 13, 
	45, 58, 65, 90, 97, 122, 58, 63, 
	95, 45, 46, 48, 57, 65, 90, 97, 
	122, 58, 63, 95, 45, 46, 48, 57, 
	65, 90, 97, 122, 32, 62, 63, 95, 
	9, 13, 45, 46, 48, 58, 65, 90, 
	97, 122, 32, 62, 9, 13, 32, 62, 
	63, 95, 9, 13, 45, 46, 48, 58, 
	65, 90, 97, 122, 60, 47, 58, 63, 
	95, 45, 57, 65, 90, 97, 122, 34, 
	92, 34, 92, 34, 39, 92, 34, 39, 
	92, 39, 92, 39, 92, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 3, 5, 5, 4, 2, 3, 2, 
	2, 5, 5, 1, 2, 7, 7, 6, 
	4, 4, 7, 3, 3, 3, 7, 2, 
	2, 7, 6, 4, 4, 3, 3, 8, 
	8, 7, 5, 4, 8, 4, 8, 7, 
	3, 2, 5, 3, 3, 4, 2, 4, 
	0, 1, 4, 0, 0, 2, 2, 3, 
	3, 2, 2, 0
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 4, 4, 4, 5, 1, 1, 0, 
	0, 4, 4, 0, 0, 4, 4, 5, 
	1, 1, 4, 0, 0, 0, 4, 0, 
	0, 4, 5, 1, 1, 0, 0, 4, 
	4, 5, 1, 1, 4, 0, 4, 4, 
	0, 0, 4, 4, 4, 5, 1, 5, 
	0, 0, 3, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 8, 18, 28, 38, 42, 47, 
	50, 53, 63, 73, 75, 78, 90, 102, 
	114, 120, 126, 138, 142, 146, 150, 162, 
	165, 168, 180, 192, 198, 204, 208, 212, 
	225, 238, 251, 258, 264, 277, 282, 295, 
	307, 311, 314, 324, 332, 340, 350, 354, 
	364, 365, 367, 375, 376, 377, 380, 383, 
	387, 391, 394, 397
]

class << self
	attr_accessor :_parser_trans_targs
	private :_parser_trans_targs, :_parser_trans_targs=
end
self._parser_trans_targs = [
	2, 1, 1, 1, 1, 1, 1, 49, 
	3, 11, 52, 42, 42, 3, 42, 42, 
	42, 49, 3, 11, 52, 4, 4, 3, 
	4, 4, 4, 49, 5, 6, 4, 4, 
	5, 4, 4, 4, 4, 49, 5, 6, 
	5, 49, 6, 7, 41, 6, 49, 9, 
	12, 8, 9, 12, 8, 10, 11, 52, 
	4, 4, 10, 4, 4, 4, 49, 10, 
	11, 52, 4, 4, 10, 4, 4, 4, 
	49, 51, 49, 13, 12, 8, 14, 9, 
	19, 54, 15, 12, 15, 14, 15, 15, 
	15, 8, 14, 9, 19, 54, 15, 12, 
	15, 14, 15, 15, 15, 8, 16, 9, 
	17, 15, 12, 15, 16, 15, 15, 15, 
	15, 8, 16, 9, 17, 12, 16, 8, 
	17, 18, 20, 12, 17, 8, 14, 9, 
	19, 54, 15, 12, 15, 14, 15, 15, 
	15, 8, 9, 53, 12, 8, 22, 13, 
	30, 21, 22, 13, 30, 21, 25, 9, 
	40, 58, 26, 24, 26, 25, 26, 26, 
	26, 23, 9, 24, 23, 22, 24, 23, 
	25, 9, 40, 58, 26, 24, 26, 25, 
	26, 26, 26, 23, 27, 9, 28, 26, 
	24, 26, 27, 26, 26, 26, 26, 23, 
	27, 9, 28, 24, 27, 23, 28, 29, 
	39, 24, 28, 23, 22, 13, 30, 21, 
	31, 31, 30, 21, 32, 22, 13, 37, 
	56, 33, 30, 33, 32, 33, 33, 33, 
	21, 32, 22, 13, 37, 56, 33, 30, 
	33, 32, 33, 33, 33, 21, 34, 22, 
	13, 35, 33, 30, 33, 34, 33, 33, 
	33, 33, 21, 34, 22, 13, 35, 30, 
	34, 21, 35, 36, 38, 30, 35, 21, 
	32, 22, 13, 37, 56, 33, 30, 33, 
	32, 33, 33, 33, 21, 22, 13, 55, 
	30, 21, 32, 22, 13, 37, 56, 33, 
	30, 33, 32, 33, 33, 33, 21, 25, 
	9, 40, 58, 26, 24, 26, 25, 26, 
	26, 26, 23, 9, 57, 24, 23, 9, 
	24, 23, 3, 11, 52, 42, 42, 3, 
	42, 42, 42, 49, 45, 44, 44, 44, 
	44, 44, 44, 49, 45, 44, 44, 44, 
	44, 44, 44, 49, 46, 59, 47, 47, 
	46, 47, 47, 47, 47, 49, 46, 59, 
	46, 49, 46, 59, 47, 47, 46, 47, 
	47, 47, 47, 49, 0, 50, 49, 43, 
	2, 1, 1, 1, 1, 1, 49, 49, 
	49, 9, 12, 8, 9, 12, 8, 22, 
	13, 30, 21, 22, 13, 30, 21, 9, 
	24, 23, 9, 24, 23, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 0
]

class << self
	attr_accessor :_parser_trans_actions
	private :_parser_trans_actions, :_parser_trans_actions=
end
self._parser_trans_actions = [
	3, 0, 0, 0, 0, 0, 0, 29, 
	36, 36, 36, 5, 5, 36, 5, 5, 
	5, 29, 0, 0, 0, 13, 13, 0, 
	13, 13, 13, 29, 15, 15, 0, 0, 
	15, 0, 0, 0, 0, 31, 0, 0, 
	0, 31, 0, 0, 0, 0, 31, 48, 
	17, 17, 19, 0, 0, 9, 39, 39, 
	69, 69, 9, 69, 69, 69, 31, 0, 
	11, 11, 42, 42, 0, 42, 42, 42, 
	31, 0, 31, 19, 0, 0, 9, 19, 
	39, 86, 69, 0, 69, 9, 69, 69, 
	69, 0, 0, 19, 11, 77, 42, 0, 
	42, 0, 42, 42, 42, 0, 15, 19, 
	15, 0, 0, 0, 15, 0, 0, 0, 
	0, 0, 0, 19, 0, 0, 0, 0, 
	0, 19, 0, 0, 0, 0, 45, 48, 
	73, 91, 81, 17, 81, 45, 81, 81, 
	81, 17, 19, 63, 0, 0, 51, 48, 
	17, 17, 19, 19, 0, 0, 9, 19, 
	39, 86, 69, 0, 69, 9, 69, 69, 
	69, 0, 19, 0, 0, 19, 0, 0, 
	0, 19, 11, 77, 42, 0, 42, 0, 
	42, 42, 42, 0, 15, 19, 15, 0, 
	0, 0, 15, 0, 0, 0, 0, 0, 
	0, 19, 0, 0, 0, 0, 0, 0, 
	19, 0, 0, 0, 48, 48, 17, 17, 
	19, 19, 0, 0, 9, 19, 19, 39, 
	86, 69, 0, 69, 9, 69, 69, 69, 
	0, 0, 19, 19, 11, 77, 42, 0, 
	42, 0, 42, 42, 42, 0, 15, 19, 
	19, 15, 0, 0, 0, 15, 0, 0, 
	0, 0, 0, 0, 19, 19, 0, 0, 
	0, 0, 0, 19, 19, 0, 0, 0, 
	45, 48, 48, 73, 91, 81, 17, 81, 
	45, 81, 81, 81, 17, 19, 19, 63, 
	0, 0, 45, 51, 48, 73, 91, 81, 
	17, 81, 45, 81, 81, 81, 17, 45, 
	48, 73, 91, 81, 17, 81, 45, 81, 
	81, 81, 17, 19, 63, 0, 0, 48, 
	17, 17, 7, 7, 7, 0, 0, 7, 
	0, 0, 0, 29, 33, 1, 1, 1, 
	1, 1, 1, 29, 3, 0, 0, 0, 
	0, 0, 0, 29, 36, 36, 5, 5, 
	36, 5, 5, 5, 5, 29, 0, 0, 
	0, 29, 7, 7, 0, 0, 7, 0, 
	0, 0, 0, 29, 0, 66, 25, 0, 
	33, 1, 1, 1, 1, 1, 27, 57, 
	54, 19, 0, 0, 19, 0, 0, 19, 
	19, 0, 0, 19, 19, 0, 0, 19, 
	0, 0, 19, 0, 0, 60, 29, 29, 
	29, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 29, 
	29, 29, 29, 29, 29, 27, 57, 54, 
	57, 54, 57, 54, 57, 54, 60, 0
]

class << self
	attr_accessor :_parser_to_state_actions
	private :_parser_to_state_actions, :_parser_to_state_actions=
end
self._parser_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	21, 21, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_parser_from_state_actions
	private :_parser_from_state_actions, :_parser_from_state_actions=
end
self._parser_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 23, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_parser_eof_trans
	private :_parser_eof_trans, :_parser_eof_trans=
end
self._parser_eof_trans = [
	0, 445, 445, 445, 439, 439, 439, 439, 
	439, 439, 439, 439, 439, 439, 439, 439, 
	439, 439, 439, 439, 439, 439, 439, 439, 
	439, 439, 439, 439, 439, 439, 439, 439, 
	439, 439, 439, 439, 439, 439, 439, 439, 
	439, 439, 445, 445, 445, 445, 445, 445, 
	0, 0, 446, 453, 454, 453, 454, 453, 
	454, 453, 454, 455
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 49;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 49;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_Closeout
end
self.parser_en_Closeout = 48;
class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 49;

# line 117 "scan.rl"
      
# line 381 "scan.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = parser_start
	ts = nil
	te = nil
	act = 0
end
# line 118 "scan.rl"
      
# line 392 "scan.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_acts = _parser_from_state_actions[cs]
	_nacts = _parser_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _parser_actions[_acts - 1]
			when 14 then
# line 1 "scan.rl"
		begin
ts = p
		end
# line 1 "scan.rl"
# line 427 "scan.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _parser_key_offsets[cs]
	_trans = _parser_index_offsets[cs]
	_klen = _parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	end
	if _goto_level <= _eof_trans
	cs = _parser_trans_targs[_trans]
	if _parser_trans_actions[_trans] != 0
		_acts = _parser_trans_actions[_trans]
		_nacts = _parser_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _parser_actions[_acts - 1]
when 0 then
# line 5 "scan.rl"
		begin
 mark_pfx = p 		end
# line 5 "scan.rl"
when 1 then
# line 6 "scan.rl"
		begin

	  if data[mark_pfx..p-1] != @prefix
	    cs = 48;
    end
			end
# line 6 "scan.rl"
when 2 then
# line 11 "scan.rl"
		begin
 mark_stg = p 		end
# line 11 "scan.rl"
when 3 then
# line 12 "scan.rl"
		begin
 @starttag = data[mark_stg..p-1] 		end
# line 12 "scan.rl"
when 4 then
# line 13 "scan.rl"
		begin
 mark_attr = p 		end
# line 13 "scan.rl"
when 5 then
# line 14 "scan.rl"
		begin

	  @attrs[@nat] = @vat 
			end
# line 14 "scan.rl"
when 6 then
# line 23 "scan.rl"
		begin
 mark_nat = p 		end
# line 23 "scan.rl"
when 7 then
# line 24 "scan.rl"
		begin
 @nat = data[mark_nat..p-1] 		end
# line 24 "scan.rl"
when 8 then
# line 25 "scan.rl"
		begin
 mark_vat = p 		end
# line 25 "scan.rl"
when 9 then
# line 26 "scan.rl"
		begin
 @vat = data[mark_vat..p-1] 		end
# line 26 "scan.rl"
when 10 then
# line 28 "scan.rl"
		begin
 @flavor = :open 		end
# line 28 "scan.rl"
when 11 then
# line 29 "scan.rl"
		begin
 @flavor = :self 		end
# line 29 "scan.rl"
when 12 then
# line 30 "scan.rl"
		begin
 @flavor = :close 		end
# line 30 "scan.rl"
when 15 then
# line 1 "scan.rl"
		begin
te = p+1
		end
# line 1 "scan.rl"
when 16 then
# line 68 "scan.rl"
		begin
act = 1;		end
# line 68 "scan.rl"
when 17 then
# line 77 "scan.rl"
		begin
act = 2;		end
# line 77 "scan.rl"
when 18 then
# line 77 "scan.rl"
		begin
te = p+1
 begin 
	    @nodes.last << data[p]
	    @tagstart = p
	   end
		end
# line 77 "scan.rl"
when 19 then
# line 68 "scan.rl"
		begin
te = p
p = p - 1; begin 
	    tag = {:prefix=>@prefix, :name=>@starttag, :flavor => @flavor, :attrs => @attrs}
	    @prefix = nil
	    @name = nil
	    @flavor = :tasteless
	    @attrs = {}
	    @nodes << tag << ''
      	begin
		p += 1
		_trigger_goto = true
		_goto_level = _out
		break
	end

	   end
		end
# line 68 "scan.rl"
when 20 then
# line 77 "scan.rl"
		begin
te = p
p = p - 1; begin 
	    @nodes.last << data[p]
	    @tagstart = p
	   end
		end
# line 77 "scan.rl"
when 21 then
# line 77 "scan.rl"
		begin
 begin p = ((te))-1; end
 begin 
	    @nodes.last << data[p]
	    @tagstart = p
	   end
		end
# line 77 "scan.rl"
when 22 then
# line 1 "scan.rl"
		begin
	case act
	when 1 then
	begin begin p = ((te))-1; end

	    tag = {:prefix=>@prefix, :name=>@starttag, :flavor => @flavor, :attrs => @attrs}
	    @prefix = nil
	    @name = nil
	    @flavor = :tasteless
	    @attrs = {}
	    @nodes << tag << ''
      	begin
		p += 1
		_trigger_goto = true
		_goto_level = _out
		break
	end

	  end
	when 2 then
	begin begin p = ((te))-1; end

	    @nodes.last << data[p]
	    @tagstart = p
	  end
end 
			end
# line 1 "scan.rl"
# line 661 "scan.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _parser_to_state_actions[cs]
	_nacts = _parser_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _parser_actions[_acts - 1]
when 13 then
# line 1 "scan.rl"
		begin
ts = nil;		end
# line 1 "scan.rl"
# line 682 "scan.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _parser_eof_trans[cs] > 0
		_trans = _parser_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end
# line 119 "scan.rl"
      return p
    end
  end
end