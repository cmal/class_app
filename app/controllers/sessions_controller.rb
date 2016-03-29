# coding: utf-8
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user, flash: { success: "已登入" }
    else
      flash.now[:danger] = "电子邮箱或密码错误!"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, flash: { info: "已登出" }
    #flash.now[:info] = "已登出"
  end
end
