# coding: utf-8
require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @user = users(:user2)
    @klass = klasses(:klass1)
  end

  test "should show user profile and klasses" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select '.user-name'
    assert_select '.user-email'
    assert_select '.user-klasses'
  end

  test "should redirect when not logged in with friendly forwarding" do
    get user_path(@user)
    assert_redirected_to login_path
    post login_path, session: { email: @user.email, password: "password" }
    assert_redirected_to @user
    follow_redirect!
    assert_select 'th', count: 2
    assert_select 'a[href=?]', klass_path(@klass), text: '删除',
                  method: :delete, count: 0
  end

  test "should have different layout with admin" do
    log_in_as(@admin)
    @user.join(@klass) unless @user.klasses.include?(@klass)
    get user_path(@user)
    assert_select 'th', count: 3
    assert_select 'a[href=?]', klass_path(@klass), text: @klass.name
    assert_select 'a[href=?]', edit_klass_path(@klass), text: '改名'
    assert_select 'a[href=?]', klass_path(@klass), text: '删除',
                  method: :delete
  end
  
end
