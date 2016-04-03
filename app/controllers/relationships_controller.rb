class RelationshipsController < ApplicationController
  before_action :admin_user
  def create
    @klass = Klass.find(params[:klass_id])
    @user = User.find(params[:member_id])
    @user.join(@klass)
    respond_to do |format|
      format.html { redirect_to @klass }
      format.js
    end
  end

  def destroy
    relationship = Relationship.find(params[:id])
    @klass = relationship.klass
    @user = relationship.member
    @user.leave(@klass)
    respond_to do |format|
      format.html { redirect_to @klass }
      format.js
    end
  end
end
