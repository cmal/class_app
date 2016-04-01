require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user1
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user1, user: { name: @user1.name, email: @user1.email }
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get :edit, id: @user1
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    patch :update, id: @user1, user: { name: @user1.name, email: @user1.email }
    assert_redirected_to root_url
  end
end
