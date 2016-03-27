require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "user@invalid",
                               password:              "testpass",
                               password_confirmation: "wrong" }
    end
    assert_template 'users/new'
  end
  
  test "valid signup information" do
    get signup_path
    email    = "user@example.com"
    password = "password"
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: email,
                                            password:              password,
                                            password_confirmation: password }
    end
    assert_template 'users/show'
  end
end
