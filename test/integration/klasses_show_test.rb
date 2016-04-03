# coding: utf-8
require 'test_helper'

class KlassesShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @user = users(:user2)
    @klass = klasses(:klass1)
  end

  test "should show klass members" do
    log_in_as(@admin)
    get klass_path(@klass)
    assert_template 'klasses/show'
    assert_select '.panel'
    assert_select '.members'
  end

  test "should redirect when not logged in with friendly forwarding" do
    @user.join(@klass) unless @user.klasses.include?(@klass)
    get klass_path(@klass)
    assert_redirected_to login_path
    post login_path, session: { email: @user.email, password: "password" }
    assert_redirected_to @klass
    follow_redirect!
    assert_select 'th', count: 2
    member = @klass.members.first
    assert_select 'a[href=?]', user_path(member), text: '删除',
                  method: :delete, count: 0
  end
  test "should redirect when accessing klasses which user is not a member except for admin" do
    @user.leave(@klass) if @user.klasses.include?(@klass)
    log_in_as(@user)
    get klass_path(@klass)
    assert_redirected_to login_path
    delete logout_path
    @admin.leave(@klass) if @admin.klasses.include?(@klass)
    log_in_as(@admin)
    get klass_path(@klass)
    assert_template 'klasses/show'
  end

  test "should have different layout with admin" do
    log_in_as(@admin)
    @admin.join(@klass) unless @admin.klasses.any?
    get klass_path(@klass)
    assert_select 'th', count: 3
    member = @klass.members.first
    assert_select 'a[href=?]', user_path(member), text: member.name
    assert_select 'a[href=?]', edit_user_path(member), text: '编辑'
    assert_select 'a[href=?]', relationship_path(
                    member.relationships.find_by(klass_id: @klass.id)),
                  text: '移除', method: :delete
  end
end
