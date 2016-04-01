# coding: utf-8
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "密码不符",
                               email: "user@invalid",
                               password:              "testpass",
                               password_confirmation: "wrong" }
    end
    assert_no_difference 'User.count' do
      post users_path, user: { name: "错误 中文名",
                               email: "user@invalid",
                               password:              "rightpass",
                               password_confirmation: "rightpass" }
    end
    assert_no_difference 'User.count' do
      post users_path, user: { name: "Right English Name",
                               email: "user@invalid",
                               password:              "rightpass",
                               password_confirmation: "rightpass" }
    end
    assert_template 'users/new'
  end
  
  test "valid signup information" do
    get signup_path
    email    = "user@example.com"
    password = "password"
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "正确用户",
                                            email: email,
                                            password:              password,
                                            password_confirmation: password }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
