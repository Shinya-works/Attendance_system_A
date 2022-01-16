class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  def log_in_user  
    if logged_in?
      store_location
      flash[:danger] = "すでにログインしています。"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def admin_user_or_correctuser
    @user = User.find(params[:id]) if @user.blank?
    unless current_user?(@user) || current_user.admin
    flash[:danger] = "編集権限がありません。"
    redirect_to(root_url)
    end
  end
end
