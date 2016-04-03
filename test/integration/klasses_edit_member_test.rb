require 'test_helper'

class KlassesEditMemberTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @klass = klasses(:klass1)
    log_in_as(@admin)
  end

  test "should show member list and non-member list" do
    get edit_member_path(@klass)
    assert_template 'klasses/edit_member'
    assert_select '.panel', count: 2
    assert_select '.btn', count: User.count
    User.all.each do |user|
      assert_select '#user-'+user.id.to_s, user.name, count: 1
    end
  end
end
