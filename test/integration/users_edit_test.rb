require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end

  test "unsuccessful edit profile" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), user: { name: ' ',
                                    email: 'email@fail.ed',
                                    password: 'user1pass' }
    assert_template 'users/edit'
  end

  test "successful edit profile with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Right Name"
    email = "right@email.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "user1pass" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
  
  test "unsuccessful update password" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), user: { name: @user.name,
                                    email: @user.email,
                                    password: 'user1pass',
                                    new_password: 'newpassword',
                                    new_password_confirmation: 'unmatched' }
    assert_template 'users/edit'
  end

  test "successful update password" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = @user.name
    email = @user.email
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "user1pass",
                                    new_password: "newpassword",
                                    new_password_confirmation: "newpassword" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
