require 'test_helper'

class DelegatingOpenStructTest < Minitest::Test
  def test_unknown_method_introspection_does_not_raise
    locals = Radius::DelegatingOpenStruct.new

    refute_respond_to locals, :to_ary
    refute_respond_to locals, :unknown
  end

  def test_stored_values_report_getter_and_setter
    locals = Radius::DelegatingOpenStruct.new
    locals.title = 'Hello'

    assert_respond_to locals, :title
    assert_respond_to locals, :title=
    assert_equal 'Hello', locals.title
  end

  def test_reports_public_methods_of_the_delegated_object
    locals = Radius::DelegatingOpenStruct.new('hello')

    assert_respond_to locals, :upcase
    assert_equal 'HELLO', locals.upcase
    refute_respond_to locals, :unknown
  end

  def test_does_not_advertise_private_methods_it_cannot_delegate
    object = Object.new
    def object.hidden; 'private'; end
    object.singleton_class.send(:private, :hidden)
    locals = Radius::DelegatingOpenStruct.new(object)

    refute locals.respond_to?(:hidden, true)
    assert_raises(NoMethodError) { locals.hidden }
  end
end
