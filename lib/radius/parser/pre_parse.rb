# line 1 "pre_parse.rl"
# line 63 "pre_parse.rl"


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
    	
# line 43 "pre_parse.rb"
class << self
	attr_accessor :_pre_parse_actions
	private :_pre_parse_actions, :_pre_parse_actions=
end
self._pre_parse_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 6, 1, 7, 1, 
	8, 1, 9, 1, 10, 1, 11, 1, 
	12, 1, 13, 1, 14, 2, 0, 1, 
	2, 1, 2, 2, 2, 3, 2, 5, 
	7, 2, 6, 14, 2, 9, 4, 2, 
	9, 10, 2, 10, 9, 2, 10, 11, 
	2, 10, 12, 2, 11, 14, 2, 12, 
	14, 2, 13, 14, 3, 4, 5, 7, 
	3, 15, 18, 16, 3, 15, 18, 17, 
	4, 5, 15, 18, 16, 4, 5, 15, 
	18, 17, 4, 9, 4, 5, 7, 5, 
	4, 5, 15, 18, 16, 5, 4, 5, 
	15, 18, 17, 6, 9, 4, 5, 15, 
	18, 16, 6, 9, 4, 5, 15, 18, 
	17
]

class << self
	attr_accessor :_pre_parse_key_offsets
	private :_pre_parse_key_offsets, :_pre_parse_key_offsets=
end
self._pre_parse_key_offsets = [
	0, 1, 11, 11, 22, 36, 49, 63, 
	67, 72, 74, 76, 89, 102, 103, 103, 
	103, 105, 120, 135, 151, 157, 163, 178, 
	181, 183, 185, 188, 191, 206, 208, 210, 
	225, 241, 247, 253, 256, 259, 275, 291, 
	308, 315, 321, 337, 341, 344, 347, 363, 
	378, 381, 383, 385, 387, 401, 412, 423, 
	438, 442, 442
]

class << self
	attr_accessor :_pre_parse_trans_keys
	private :_pre_parse_trans_keys, :_pre_parse_trans_keys=
end
self._pre_parse_trans_keys = [
	60, 47, 58, 63, 95, 45, 57, 65, 
	90, 97, 122, 58, 63, 95, 45, 46, 
	48, 57, 65, 90, 97, 122, 32, 58, 
	63, 95, 9, 13, 45, 46, 48, 57, 
	65, 90, 97, 122, 32, 47, 62, 63, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 32, 61, 63, 95, 9, 13, 45, 
	46, 48, 58, 65, 90, 97, 122, 32, 
	61, 9, 13, 32, 34, 39, 9, 13, 
	34, 92, 34, 92, 32, 47, 62, 63, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 32, 47, 62, 63, 95, 9, 13, 
	45, 58, 65, 90, 97, 122, 62, 34, 
	92, 32, 34, 47, 62, 63, 92, 95, 
	9, 13, 45, 58, 65, 90, 97, 122, 
	32, 34, 47, 62, 63, 92, 95, 9, 
	13, 45, 58, 65, 90, 97, 122, 32, 
	34, 61, 63, 92, 95, 9, 13, 45, 
	46, 48, 58, 65, 90, 97, 122, 32, 
	34, 61, 92, 9, 13, 32, 34, 39, 
	92, 9, 13, 32, 34, 47, 62, 63, 
	92, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 34, 62, 92, 34, 92, 34, 
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
	122, 34, 39, 62, 92, 34, 39, 92, 
	34, 39, 92, 32, 34, 39, 47, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 32, 39, 47, 62, 63, 
	92, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 39, 62, 92, 39, 92, 39, 
	92, 39, 92, 32, 58, 63, 95, 9, 
	13, 45, 46, 48, 57, 65, 90, 97, 
	122, 58, 63, 95, 45, 46, 48, 57, 
	65, 90, 97, 122, 58, 63, 95, 45, 
	46, 48, 57, 65, 90, 97, 122, 32, 
	58, 62, 63, 95, 9, 13, 45, 46, 
	48, 57, 65, 90, 97, 122, 32, 62, 
	9, 13, 32, 58, 62, 63, 95, 9, 
	13, 45, 46, 48, 57, 65, 90, 97, 
	122, 0
]

class << self
	attr_accessor :_pre_parse_single_lengths
	private :_pre_parse_single_lengths, :_pre_parse_single_lengths=
end
self._pre_parse_single_lengths = [
	1, 4, 0, 3, 4, 5, 4, 2, 
	3, 2, 2, 5, 5, 1, 0, 0, 
	2, 7, 7, 6, 4, 4, 7, 3, 
	2, 2, 3, 3, 7, 2, 2, 7, 
	6, 4, 4, 3, 3, 8, 8, 7, 
	5, 4, 8, 4, 3, 3, 8, 7, 
	3, 2, 2, 2, 4, 3, 3, 5, 
	2, 0, 5
]

class << self
	attr_accessor :_pre_parse_range_lengths
	private :_pre_parse_range_lengths, :_pre_parse_range_lengths=
end
self._pre_parse_range_lengths = [
	0, 3, 0, 4, 5, 4, 5, 1, 
	1, 0, 0, 4, 4, 0, 0, 0, 
	0, 4, 4, 5, 1, 1, 4, 0, 
	0, 0, 0, 0, 4, 0, 0, 4, 
	5, 1, 1, 0, 0, 4, 4, 5, 
	1, 1, 4, 0, 0, 0, 4, 4, 
	0, 0, 0, 0, 5, 4, 4, 5, 
	1, 0, 5
]

class << self
	attr_accessor :_pre_parse_index_offsets
	private :_pre_parse_index_offsets, :_pre_parse_index_offsets=
end
self._pre_parse_index_offsets = [
	0, 2, 10, 11, 19, 29, 39, 49, 
	53, 58, 61, 64, 74, 84, 86, 87, 
	88, 91, 103, 115, 127, 133, 139, 151, 
	155, 158, 161, 165, 169, 181, 184, 187, 
	199, 211, 217, 223, 227, 231, 244, 257, 
	270, 277, 283, 296, 301, 305, 309, 322, 
	334, 338, 341, 344, 347, 357, 365, 373, 
	384, 388, 389
]

class << self
	attr_accessor :_pre_parse_trans_targs
	private :_pre_parse_trans_targs, :_pre_parse_trans_targs=
end
self._pre_parse_trans_targs = [
	1, 0, 53, 4, 3, 3, 3, 3, 
	3, 2, 2, 4, 3, 3, 3, 3, 
	3, 3, 2, 5, 4, 52, 52, 5, 
	52, 52, 52, 52, 2, 5, 13, 15, 
	6, 6, 5, 6, 6, 6, 2, 7, 
	8, 6, 6, 7, 6, 6, 6, 6, 
	2, 7, 8, 7, 2, 8, 9, 51, 
	8, 2, 11, 16, 10, 11, 16, 10, 
	12, 13, 15, 6, 6, 12, 6, 6, 
	6, 2, 12, 13, 15, 6, 6, 12, 
	6, 6, 6, 2, 14, 2, 2, 2, 
	17, 16, 10, 18, 11, 23, 25, 19, 
	16, 19, 18, 19, 19, 19, 10, 18, 
	11, 23, 25, 19, 16, 19, 18, 19, 
	19, 19, 10, 20, 11, 21, 19, 16, 
	19, 20, 19, 19, 19, 19, 10, 20, 
	11, 21, 16, 20, 10, 21, 22, 26, 
	16, 21, 10, 18, 11, 23, 25, 19, 
	16, 19, 18, 19, 19, 19, 10, 11, 
	24, 16, 10, 11, 16, 10, 11, 16, 
	10, 28, 17, 36, 27, 28, 17, 36, 
	27, 31, 11, 48, 50, 32, 30, 32, 
	31, 32, 32, 32, 29, 11, 30, 29, 
	28, 30, 29, 31, 11, 48, 50, 32, 
	30, 32, 31, 32, 32, 32, 29, 33, 
	11, 34, 32, 30, 32, 33, 32, 32, 
	32, 32, 29, 33, 11, 34, 30, 33, 
	29, 34, 35, 47, 30, 34, 29, 28, 
	17, 36, 27, 37, 37, 36, 27, 38, 
	28, 17, 43, 45, 39, 36, 39, 38, 
	39, 39, 39, 27, 38, 28, 17, 43, 
	45, 39, 36, 39, 38, 39, 39, 39, 
	27, 40, 28, 17, 41, 39, 36, 39, 
	40, 39, 39, 39, 39, 27, 40, 28, 
	17, 41, 36, 40, 27, 41, 42, 46, 
	36, 41, 27, 38, 28, 17, 43, 45, 
	39, 36, 39, 38, 39, 39, 39, 27, 
	28, 17, 44, 36, 27, 28, 17, 36, 
	27, 28, 17, 36, 27, 38, 28, 17, 
	43, 45, 39, 36, 39, 38, 39, 39, 
	39, 27, 31, 11, 48, 50, 32, 30, 
	32, 31, 32, 32, 32, 29, 11, 49, 
	30, 29, 11, 30, 29, 11, 30, 29, 
	11, 30, 29, 5, 4, 52, 52, 5, 
	52, 52, 52, 52, 2, 55, 54, 54, 
	54, 54, 54, 54, 2, 55, 54, 54, 
	54, 54, 54, 54, 2, 56, 55, 57, 
	58, 58, 56, 58, 58, 58, 58, 2, 
	56, 57, 56, 2, 2, 56, 55, 57, 
	58, 58, 56, 58, 58, 58, 58, 2, 
	0
]

class << self
	attr_accessor :_pre_parse_trans_actions
	private :_pre_parse_trans_actions, :_pre_parse_trans_actions=
end
self._pre_parse_trans_actions = [
	11, 11, 0, 29, 1, 1, 1, 1, 
	1, 0, 0, 3, 0, 0, 0, 0, 
	0, 0, 0, 35, 32, 5, 5, 35, 
	5, 5, 5, 5, 0, 0, 72, 76, 
	13, 13, 0, 13, 13, 13, 0, 15, 
	15, 0, 0, 15, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 47, 17, 17, 19, 0, 0, 
	9, 95, 101, 68, 68, 9, 68, 68, 
	68, 0, 0, 80, 85, 38, 38, 0, 
	38, 38, 38, 0, 0, 0, 23, 21, 
	19, 0, 0, 9, 19, 95, 101, 68, 
	0, 68, 9, 68, 68, 68, 0, 0, 
	19, 80, 85, 38, 0, 38, 0, 38, 
	38, 38, 0, 15, 19, 15, 0, 0, 
	0, 15, 0, 0, 0, 0, 0, 0, 
	19, 0, 0, 0, 0, 0, 19, 0, 
	0, 0, 0, 44, 47, 107, 114, 90, 
	17, 90, 44, 90, 90, 90, 17, 19, 
	0, 0, 0, 56, 23, 23, 53, 21, 
	21, 50, 47, 17, 17, 19, 19, 0, 
	0, 9, 19, 95, 101, 68, 0, 68, 
	9, 68, 68, 68, 0, 19, 0, 0, 
	19, 0, 0, 0, 19, 80, 85, 38, 
	0, 38, 0, 38, 38, 38, 0, 15, 
	19, 15, 0, 0, 0, 15, 0, 0, 
	0, 0, 0, 0, 19, 0, 0, 0, 
	0, 0, 0, 19, 0, 0, 0, 47, 
	47, 17, 17, 19, 19, 0, 0, 9, 
	19, 19, 95, 101, 68, 0, 68, 9, 
	68, 68, 68, 0, 0, 19, 19, 80, 
	85, 38, 0, 38, 0, 38, 38, 38, 
	0, 15, 19, 19, 15, 0, 0, 0, 
	15, 0, 0, 0, 0, 0, 0, 19, 
	19, 0, 0, 0, 0, 0, 19, 19, 
	0, 0, 0, 44, 47, 47, 107, 114, 
	90, 17, 90, 44, 90, 90, 90, 17, 
	19, 19, 0, 0, 0, 56, 56, 23, 
	23, 53, 53, 21, 21, 44, 50, 47, 
	107, 114, 90, 17, 90, 44, 90, 90, 
	90, 17, 44, 47, 107, 114, 90, 17, 
	90, 44, 90, 90, 90, 17, 19, 0, 
	0, 0, 56, 23, 23, 53, 21, 21, 
	47, 17, 17, 7, 3, 0, 0, 7, 
	0, 0, 0, 0, 0, 29, 1, 1, 
	1, 1, 1, 1, 0, 3, 0, 0, 
	0, 0, 0, 0, 0, 35, 32, 35, 
	5, 5, 35, 5, 5, 5, 5, 0, 
	0, 0, 0, 0, 25, 7, 3, 7, 
	0, 0, 7, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_pre_parse_eof_actions
	private :_pre_parse_eof_actions, :_pre_parse_eof_actions=
end
self._pre_parse_eof_actions = [
	41, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 62, 59, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	62, 59, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 62, 59, 27, 27, 
	27, 62, 59, 27, 27, 27, 27, 27, 
	27, 65, 27
]

class << self
	attr_accessor :pre_parse_start
end
self.pre_parse_start = 0;
class << self
	attr_accessor :pre_parse_first_final
end
self.pre_parse_first_final = 0;
class << self
	attr_accessor :pre_parse_error
end
self.pre_parse_error = -1;

class << self
	attr_accessor :pre_parse_en_main
end
self.pre_parse_en_main = 0;

# line 102 "pre_parse.rl"
    	
# line 343 "pre_parse.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = pre_parse_start
end
# line 103 "pre_parse.rl"
    	
# line 351 "pre_parse.rb"
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
	end
	if _goto_level <= _resume
	_keys = _pre_parse_key_offsets[cs]
	_trans = _pre_parse_index_offsets[cs]
	_klen = _pre_parse_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _pre_parse_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _pre_parse_trans_keys[_mid]
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
	  _klen = _pre_parse_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _pre_parse_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _pre_parse_trans_keys[_mid+1]
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
	cs = _pre_parse_trans_targs[_trans]
	if _pre_parse_trans_actions[_trans] != 0
		_acts = _pre_parse_trans_actions[_trans]
		_nacts = _pre_parse_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _pre_parse_actions[_acts - 1]
when 0 then
# line 4 "pre_parse.rl"
		begin
 mark_pfx = p 		end
# line 4 "pre_parse.rl"
when 1 then
# line 5 "pre_parse.rl"
		begin
 @prefix = data[mark_pfx..p-1] 		end
# line 5 "pre_parse.rl"
when 2 then
# line 6 "pre_parse.rl"
		begin
 mark_stg = p 		end
# line 6 "pre_parse.rl"
when 3 then
# line 7 "pre_parse.rl"
		begin
 @starttag = data[mark_stg..p-1] 		end
# line 7 "pre_parse.rl"
when 4 then
# line 8 "pre_parse.rl"
		begin
 mark_attr = p 		end
# line 8 "pre_parse.rl"
when 5 then
# line 9 "pre_parse.rl"
		begin

	  @attrs[@nat] = @vat 
			end
# line 9 "pre_parse.rl"
when 6 then
# line 13 "pre_parse.rl"
		begin

	  @prematch_end = p
	  @prematch = data[0..p] if p > 0
			end
# line 13 "pre_parse.rl"
when 7 then
# line 18 "pre_parse.rl"
		begin
 mark_nat = p 		end
# line 18 "pre_parse.rl"
when 8 then
# line 19 "pre_parse.rl"
		begin
 @nat = data[mark_nat..p-1] 		end
# line 19 "pre_parse.rl"
when 9 then
# line 20 "pre_parse.rl"
		begin
 mark_vat = p 		end
# line 20 "pre_parse.rl"
when 10 then
# line 21 "pre_parse.rl"
		begin
 @vat = data[mark_vat..p-1] 		end
# line 21 "pre_parse.rl"
when 11 then
# line 23 "pre_parse.rl"
		begin
 @flavor = :open 		end
# line 23 "pre_parse.rl"
when 12 then
# line 24 "pre_parse.rl"
		begin
 @flavor = :self 		end
# line 24 "pre_parse.rl"
when 13 then
# line 25 "pre_parse.rl"
		begin
 @flavor = :close 		end
# line 25 "pre_parse.rl"
when 15 then
# line 47 "pre_parse.rl"
		begin
$stderr.puts "left attrs #{@attrs.inspect}"		end
# line 47 "pre_parse.rl"
when 16 then
# line 49 "pre_parse.rl"
		begin
$stderr.puts "checking close"		end
# line 49 "pre_parse.rl"
when 17 then
# line 50 "pre_parse.rl"
		begin
$stderr.puts "checking open"		end
# line 50 "pre_parse.rl"
when 18 then
# line 53 "pre_parse.rl"
		begin
$stderr.puts "looking for trailer #{@data[p..p+2]}"		end
# line 53 "pre_parse.rl"
# line 522 "pre_parse.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	__acts = _pre_parse_eof_actions[cs]
	__nacts =  _pre_parse_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _pre_parse_actions[__acts - 1]
when 6 then
# line 13 "pre_parse.rl"
		begin

	  @prematch_end = p
	  @prematch = data[0..p] if p > 0
			end
# line 13 "pre_parse.rl"
when 11 then
# line 23 "pre_parse.rl"
		begin
 @flavor = :open 		end
# line 23 "pre_parse.rl"
when 12 then
# line 24 "pre_parse.rl"
		begin
 @flavor = :self 		end
# line 24 "pre_parse.rl"
when 13 then
# line 25 "pre_parse.rl"
		begin
 @flavor = :close 		end
# line 25 "pre_parse.rl"
when 14 then
# line 27 "pre_parse.rl"
		begin

	  $stderr.puts "stopping at #{@data[0..p]}"
	  @cursor = p;
	  	begin
		p += 1
		_trigger_goto = true
		_goto_level = _out
		break
	end

			end
# line 27 "pre_parse.rl"
# line 584 "pre_parse.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end
# line 104 "pre_parse.rl"
    	$stderr.puts inspect
    end
  end
end