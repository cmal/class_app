# coding: utf-8
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.all.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "已成功注册！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if admin_but_not_current?
      update_by_admin
    else
      unless @user.authenticate(params[:user][:password])
        flash[:danger] = "密码错误"
        render 'edit'
      else
        unless params[:user][:new_password].blank? &&
               params[:user][:new_password_confirmation].blank?
          change_password = true
          @user.password = params[:user][:new_password]
          @user.password_confirmation = params[:user][:new_password_confirmation]
        end
        @user.assign_attributes({"name"=>params[:user][:name],
                                 "email"=>params[:user][:email]})
        @user.assign_attributes({"password"=>params[:user][:password]}) unless change_password
        if @user.save
          flash[:success] = "用户档案已更新"
          redirect_to @user
        else
          change_msg_keys!(@user.errors.messages)
          flash[:danger] = "更新密码失败"
          render 'edit'
        end
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已删除"
    redirect_to users_url
  end

  def update_by_admin
    @user.update_attributes({"name"=>params[:user][:name],
                             "email"=>params[:user][:email]})
    if @user.save(validate: false)
      flash[:success] = "用户档案已更新"
      redirect_to @user
    else
      flash[:danger] = "更新用户档案失败"
      render 'edit'
    end
  end
  private

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password,
                                   :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "请登录后修改"
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      unless (current_user?(@user) || current_user.admin?)
        flash[:danger] = "您没有变更该用户的权限"
        redirect_to root_url
      end
    end
    def admin_user
      unless current_user.admin?
        flash[:danger] = "您没有管理员权限"
        redirect_to root_url
      end
    end
    def admin_but_not_current?
      current_user.admin? && !current_user?(@user)
    end
end
