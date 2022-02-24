class AttendancesController < ApplicationController
  include AttendancesHelper
  include UsersHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month, :confirmation_one_month]
  before_action :set_user_id, only: [:update, :overwork_application, :update_overwork, :attendances_application]
  before_action :logged_in_user, only: [:update, :edit_one_month, :confirmation_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :confirmation_one_month]
  before_action :set_one_month, only: [:edit_one_month, :confirmation_one_month]
  before_action :set_attendace, only: [:update, :overwork_application, :update_overwork, :attendances_application]
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), edit_started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), edit_finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
    @users_arry = superiors_users_of_arry
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      if edit_attendances_invalid?
        days = 0
        missing_user_count = 0
        edit_attendances_params.each do |id, item|
          days += 1
          unless item[:edit_authentication_user] == ""
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          else
            missing_user_count += 1
            all_user_missing(missing_user_count, days)
          end
        end
        unless flash[:danger] == "所属長を選択してください"
          flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
          redirect_to user_url(date: params[:date])
        else
          redirect_to attendances_edit_one_month_user_url(date: params[:date])
        end
      else
        flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効なデータがあったため更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def confirmation_one_month
  end

  def list_of_employees
    @users = User.all.includes(:attendances)
  end

  def overwork_application
    @users_arry = superiors_users_of_arry
  end

  def update_overwork
    unless overwork_application_params[:business_processing_details] == ""
      @attendance.update_attributes(overwork_application_params)
      flash[:success] = "残業申請をしました"
      redirect_to @user
    else
      flash[:danger] = "業務処理内容を入力してください"
      redirect_to @user
    end
  end

  def overwork_authentication
    @user = User.find(params[:user_id])
    @users = User.includes(:attendances).where(attendances: {
      overwork_authentication_user: current_user.name,
      authentication_state_overwork: "申請中"
      })
    @attendances = Attendance.includes(:user).where(
      overwork_authentication_user: current_user.name,
      authentication_state_overwork: "申請中"
      )
  end

  def update_overwork_authentication
    @overwork_state1_count = Attendance.where(authentication_state_overwork: "申請中").count
    @overwork_state2_count = Attendance.where(authentication_state_overwork: "承認").count
    @overwork_state3_count = Attendance.where(authentication_state_overwork: "否認").count
    @overwork_state4_count = Attendance.where(authentication_state_overwork: "なし").count
    @user = User.find(params[:user_id])
    overwork_authentication_params.each do |id, item|
      if item[:overwork_authentication] == "1"
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        nil_attendances = Attendance.where(authentication_state_overwork: "なし")
        nil_attendances.update_all(overwork_authentication_user: nil, business_processing_details: nil, expected_end_time: nil, authentication_state_overwork: nil)
      end
    end
    flash[:success] = "残業申請⇒申請中を#{@overwork_state1_count}件、承認を#{@overwork_state2_count}件、
      否認を#{@overwork_state3_count}件、なしを#{@overwork_state4_count}件更新しました"
    redirect_to user_url(@user)
  end

  def attendances_application
    if attendances_application_params[:attendances_authentication_user] != ""
      @attendance.update_attributes!(attendances_application_params)
      flash[:success] = "一か月分の勤怠承認申請をしました"
    else
      flash[:danger] = "所属長を選択してください"
    end
    redirect_to @user
  end

  def attendances_authentication
    @user = User.find(params[:user_id])
    @users = User.includes(:attendances).where(attendances: {
      attendances_authentication_user: current_user.name,
      authentication_state_attendances: "申請中"
      })
    @attendances = Attendance.includes(:user).where(
      attendances_authentication_user: current_user.name,
      authentication_state_attendances: "申請中"
      )
  end

  def update_attendances_authentication
    @user = User.find(params[:user_id])
    attendances_authentication_params.each do |id, item|
      if item[:attendances_authentication] == "1"
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        nil_attendances = Attendance.where(authentication_state_attendances: "なし")
        nil_attendances.update_all(attendances_authentication_user: nil, authentication_state_attendances: nil, attendances_authentication: nil)
      end
    end 
    flash[:success] = "勤怠の承認に成功しました"
    redirect_to user_url(@user)
  end

  def edit_attendances_authentication
    @user = User.find(params[:user_id])
    @users = User.includes(:attendances).where(attendances: {
      edit_authentication_user: current_user.name,
      authentication_state_edit: "申請中"
      })
    @attendances = Attendance.includes(:user).where(
      edit_authentication_user: current_user.name,
      authentication_state_edit: "申請中"
      )
  end

  def edit_attendances_authentication_update
    @user = User.find(params[:user_id])
    edit_attendances_authentication_params.each do |id, item|
      if item[:update_authentication] == "1"
        attendance = Attendance.find(id)
        unless item[:authentication_state_edit] == "申請中" || item[:authentication_state_edit] == "なし" 
          attendance.update_attributes!(item)
          attendance.update_attributes!(started_at: attendance.edit_started_at, finished_at: attendance.edit_finished_at)
(byebug)
        end
        attendance.update!(note: nil, edit_authentication_user: nil, authentication_state_edit: nil, update_authentication: nil) if item[:authentication_state_edit] == "なし" 
      end
    end 
    flash[:success] = "勤怠変更の承認に成功しました"
    redirect_to user_url(@user)
  end

  def edit_attendances_log
    
  end

  def edit_attendances_log_reset

  end
  
  private
    
    def edit_attendances_params
      params.require(:user).permit(attendances: [
        :edit_started_at,
        :edit_finished_at,
        :note,
        :edit_next_day,
        :authentication_state_edit,
        :edit_authentication_user,
        :before_change_started_at,
        :before_change_finished_at
        ])[:attendances]
    end

    def overwork_application_params
      params.require(:attendance).permit(:next_day, :expected_end_time, :business_processing_details, :overwork_authentication_user, :authentication_state_overwork)
    end

    def overwork_authentication_params
      params.require(:user).permit(attendances: [:authentication_state_overwork, :overwork_authentication])[:attendances]
    end

    def attendances_application_params
      params.require(:attendance).permit(:authentication_state_attendances, :attendances_authentication_user)
    end

    def attendances_authentication_params
      params.require(:user).permit(attendances: [:authentication_state_attendances, :attendances_authentication])[:attendances]
    end

    def edit_attendances_authentication_params
      params.require(:user).permit(attendances: [:authentication_state_edit, :update_authentication])[:attendances]
    end

    def set_attendace
      @attendance = Attendance.find(params[:id])
    end

    def set_attendances
      @attendances = Attendance.all
    end

    def set_user_id
      @user = User.find(params[:user_id])
    end
end