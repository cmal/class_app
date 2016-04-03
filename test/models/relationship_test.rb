require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = User.first
    @klass = Klass.first
    @relationship = Relationship.new(klass_id: @klass.id, member_id: @user.id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a klass_id" do
    @relationship.klass_id = nil
    assert_not @relationship.valid?
  end

  test "should require a user_id" do
    @relationship.member_id = nil
    assert_not @relationship.valid?
  end
end
