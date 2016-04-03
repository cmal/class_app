require 'test_helper'

class KlassesEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @klass = klasses(:klass1)
    @other_klass = klasses(:klass2)
    log_in_as(@admin)
  end

  test "unsuccessful edit klass name" do
    get edit_klass_path(@klass)
    patch klass_path(@klass), klass: { name: ' ' }
    assert_not flash.empty?
    assert_template 'klasses/edit'
    patch klass_path(@klass), klass: { name: @other_klass.name }
    assert_not flash.empty?
    assert_template 'klasses/edit'
  end

  test "successful edit klass with friendly forwarding" do
    get edit_klass_path(@klass)
    name = "Right Klass Name"
    patch klass_path(@klass), klass: { name: name }
    assert_not flash.empty?
    assert_redirected_to @klass
    @klass.reload
    assert_equal @klass.name, name
  end
end
