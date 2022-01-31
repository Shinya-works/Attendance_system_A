class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # 各日の曜日を設定するための配列を定義
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルター
    
    # paramsハッシュからユーザーを取得
  def set_user
    @user = User.find(params[:id])
  end

  def set_users
    @users = User.all
  end
    
    # ログイン済みのユーザーか確認
  def logged_in_user
    unless logged_in?
      # logged_in_userにはじかれてページ遷移する前にそのページを保存
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # 未ログインのユーザーか確認
  def log_in_user
    if logged_in?
      # logged_in_userにはじかれてページ遷移する前にそのページを保存
      store_location
      flash[:danger] = "すでにログインしています。"
      redirect_to root_url
    end
  end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します
  def correct_user     
    redirect_to root_url unless current_user?(@user)
  end
  
    # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
  
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each do |day| 
          @user.attendances.create!(worked_on: day)
        end
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
