require 'test/unit'
require 'radius'

class RadiusContextTest < Test::Unit::TestCase
  
  def test_symbolize_keys
    h = Radius::Util.symbolize_keys({ 'a' => 1, :b => 2 })
    assert_equal h[:a], 1
    assert_equal h[:b], 2
  end
  
  def test_impartial_hash_delete
    h = { 'a' => 1, :b => 2 }
    assert_equal Radius::Util.impartial_hash_delete(h, :a), 1
    assert_equal Radius::Util.impartial_hash_delete(h, 'b'), 2
    assert_equal h.empty?, true
  end
  
  def test_constantize
    assert_equal Radius::Util.constantize('String'), String
  end
  
  def test_camelize
    assert_equal Radius::Util.camelize('ab_cd_ef'), 'AbCdEf'
  end
end