# coding: utf-8
class KlassesController < ApplicationController
  before_action :logged_in_user, only: [:show, :index]
  before_action :correct_user, only: [:show]
  before_action :admin_user,
                only: [:new, :edit, :update, :destroy, :edit_member]
  def index
    @klasses = Klass.all.paginate(page: params[:page])
  end

  def show
    @klass = Klass.find(params[:id])
    @members = @klass.members.paginate(page: params[:page])
  end

  def new
    @klass = Klass.new
  end
  
  def create
    @klass = Klass.new(klass_params)
    if @klass.save
      flash[:success] = "已添加班级！"
      redirect_to klasses_url
    else
      render 'new'
    end
  end

  def edit
    @klass = Klass.find(params[:id])
  end

  def update
    @klass = Klass.find(params[:id])
    @klass.update_attributes(klass_params)
    if @klass.save
      flash[:success] = "成功编辑!"
      redirect_to @klass
    else
      flash[:danger] = "编辑失败!"
      render 'edit'
    end
  end

  def destroy
    Klass.find(params[:id]).destroy
    flash[:success] = "班级已删除"
    redirect_to klasses_url
  end

  def edit_member
    @klass = Klass.find(params[:id])
  end
  private

  def klass_params
    params.require(:klass).permit(:name)
  end

  def correct_user
    @klass = Klass.find(params[:id])
    unless (current_user.klasses.include?(@klass) || current_user.admin?)
      flash[:danger] = "您没有查看该班级的权限"
      redirect_to login_url
    end
  end
end
