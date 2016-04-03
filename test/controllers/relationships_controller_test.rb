require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @klass1 = klasses(:klass1)
    @user1 = users(:user1)
  end

  test "create should require admin user" do
    assert_no_difference 'Relationship.count' do
      post :create, klass_id: @klass1.id, member_id: @user1.id
    end
    assert_redirected_to login_url
  end

  test "destroy should require admin user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
