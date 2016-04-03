require 'test_helper'

class KlassesControllerTest < ActionController::TestCase
  def setup
    @klass = klasses(:klass15)
    @admin = users(:user1)
    @user = users(:user2)
  end

  test "should redirect new/edit/show/update/destroy/edit_member when not logged in" do
    get :new
    assert_redirected_to login_url

    get :edit, id: @klass
    assert_redirected_to login_url

    get :show, id: @klass
    assert_redirected_to login_url
    
    patch :update, id: @klass, klass: { name: @klass.name }
    assert_redirected_to login_url
    
    assert_no_difference 'Klass.count' do
      delete :destroy, id: @klass
    end
    assert_redirected_to login_url

    get :edit_member, id: @klass
    assert_redirected_to login_url

  end

  test "should redirect edit/update/destroy/edit_member when logged in as a non-admin" do
    log_in_as(@user)

    get :new
    assert_redirected_to login_url

    get :edit, id: @klass
    assert_redirected_to login_url

    patch :update, id: @klass, klass: { name: @klass.name }
    assert_redirected_to login_url

    assert_no_difference 'Klass.count' do
      delete :destroy, id: @klass
    end
    assert_redirected_to login_url

    get :edit_member, id: @klass
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as wrong non-admin user" do
    log_in_as(@user)
    @user.leave(@klass) if @user.klasses.include?(@klass)
    get :show, id: @klass
    assert_redirected_to login_url
  end

  test "should get show when logged in as correct user" do
    log_in_as(@user)
    @user.join(@klass) unless @user.klasses.include?(@klass)
    get :show, id: @klass
    assert_response :success
  end

  test "should get new/show when logged in as admin user" do
    log_in_as(@admin)
    get :new
    assert_response :success

    @admin.leave(@klass) if @admin.klasses.include?(@klass)
    get :show, id: @klass
    assert_response :success
  end
  
  test "should get edit_member when logged in as admin" do
    log_in_as(@admin)
    get :edit_member, id: @klass
    assert_response :success
  end
end
