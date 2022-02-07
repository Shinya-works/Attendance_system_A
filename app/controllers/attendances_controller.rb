class AttendancesController < ApplicationController
  include AttendancesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :set_users, only: :overwork_application
  before_action :set_user_id, only: [:update, :overwork_application, :update_overwork]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_monthset_attendances
  before_action :set_attendace, only: [:update, :overwork_application, :update_overwork]
  before_action :set_applications, only: [:attendances_authentication, :update_authentication]
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      if attendances_invalid?
        attendances_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
        flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効なデータがあったため更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def list_of_employees
    @users = User.all.includes(:attendances)
  end

  def overwork_application
    superiors_users(@users)
  end

  def update_overwork
    if @attendance.update_attributes(overwork_application_params)
      flash[:success] = "残業申請をしました"
      redirect_to @user
    else
      render :overwork_application
    end
  end

  def overwork_authentication

  end

  def update_overwork_authentication
    @attendances = overwork_authentication_params.map do |id, attendance_param|
      attendance = User.all.attendance.find(id)
      attendance.update_attributes(attendance_param) if attendance.overwork_authentication == "1"
      attendance
    end
    respond_with(@attendance, location: overwork_authentication)
  end
  
  private
    
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :expected_end_time, :next_day,
        :overtime, :business_processing_details, :authentication_user, :authentication_day, :authentication_state,
        :update_authentication, :attendances_authentication])[:attendances]
    end

    def overwork_application_params
      params.require(:attendance).permit(:next_day, :expected_end_time, :authentication_user, :authentication_state)
    end

    def overwork_authentication_params
      params.permit(attendance: [:authentication_state, :overwork_authentication])[:attendance]
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

    def set_applications
      @application_users = User.all.includes(:attendances).where(attendances: {authentication_state: "申請中",
        authentication_user: current_user})
    end
end
