require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @admin = users(:user1)
    @user = users(:user2)
    @other_user = users(:user3)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit/update/destroy when not logged in" do
    get :edit, id: @user
    assert_redirected_to login_url

    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_redirected_to login_url

    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect edit/update when logged in as wrong user" do
    log_in_as(@user)
    get :edit, id: @other_user
    assert_redirected_to login_url

    patch :update, id: @other_user, user: { name: @other_user.name, email: @other_user.email }
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @other_user
    end
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as wrong non-admin user" do
    log_in_as(@user)
    get :show, id: @other_user
    assert_redirected_to login_url
  end

  test "should get show when logged in as correct user" do
    log_in_as(@user)
    get :show, id: @user
    assert_response :success
  end

  test "should get show when logged in as admin user" do
    log_in_as(@admin)
    get :show, id: @user
    assert_response :success
  end

end
