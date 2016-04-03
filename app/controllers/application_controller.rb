# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "需要先登录"
      redirect_to login_url
    end
  end

  def admin_user
    unless logged_in? && current_user.admin?
      store_location
      flash[:danger] = "需要管理员权限"
      redirect_to login_url
    end
  end
end
