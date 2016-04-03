# coding: utf-8
require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  def setup
    @klass = Klass.new(name: "正确班级名")
  end
  test "test klass should be valid" do
    assert @klass.valid?
  end
  test "name should be present" do
    @klass.name = " "
    assert_not @klass.valid?
  end
  test "name should not be too long" do
    @klass.name = "Klass" * 60
    assert_not @klass.valid?
  end
  test "name should be unique" do
    duplicate_klass = @klass.dup
    @klass.save
    assert_not duplicate_klass.valid?
  end
end
