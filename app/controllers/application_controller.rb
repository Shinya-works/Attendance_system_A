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
      flash[:success] = "ログイン中。"
      redirect_to current_user
    end
  end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します
  def id_correct_user
    unless current_user?(User.find(params[:id]))
      flash[:danger] = "あなたはユーザー本人ではありません。"
      redirect_to root_url 
    end
  end

  def user_id_correct_user
    unless current_user?(User.find(params[:user_id]))
      flash[:danger] = "あなたはユーザー本人ではありません。"
      redirect_to root_url 
    end
  end
  
    # システム管理権限所有かどうか判定します。
  def admin_user
    unless current_user.admin?
      flash[:danger] = "あなたは管理権限者ではありません。"
      redirect_to root_url 
    end
  end

  def superiors_user
    unless current_user.superiors?
      flash[:danger] = "あなたは上長権限者ではありません。"
      redirect_to root_url
    end
  end
  
  # 上長権限者もしくは一般ユーザーを許可します。
    def normal_user_or_superiors_user
      if current_user.admin?
        flash[:danger] = "あなたは管理権限者です。"
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

  def superiors_users_of_arry
    users = User.all.where(superiors: true)
                  .where.not(name: current_user.name)
    users.map { |user| user.name }
  end
end
