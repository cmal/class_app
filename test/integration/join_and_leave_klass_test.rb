require 'test_helper'

class JoinAndLeaveKlassTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @user  = users(:user2)
    @klass = klasses(:klass1)
    log_in_as(@admin)
  end
  test "should join a klass" do
    assert_difference ['@klass.members.count', '@user.klasses.count'], 1 do
      post relationships_path, member_id: @user.id, klass_id: @klass.id
    end
  end

  test "should leave a klass" do
    @user.join(@klass)
    relationship = @user.relationships.find_by(klass_id: @klass.id)
    assert_difference ['@klass.members.count', '@user.klasses.count'], -1 do
      delete relationship_path(relationship)
    end
  end

  test "should join a klass with Ajax" do
    assert_difference ['@klass.members.count', '@user.klasses.count'], 1 do
      xhr :post, relationships_path, member_id: @user.id, klass_id: @klass.id
    end
  end

  test "should leave a klass with Ajax" do
    @user.join(@klass)
    relationship = @user.relationships.find_by(klass_id: @klass.id)
    assert_difference ['@klass.members.count', '@user.klasses.count'], -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
