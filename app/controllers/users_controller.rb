class UsersController < ApplicationController
  include AttendancesCsvModule
  require 'csv'
  before_action :logged_in_user, except: [:new, :create]
  before_action :log_in_user, only: [:new, :create]
  before_action :id_correct_user, only: [:show, :edit, :update]
  before_action :normal_user_or_superiors_user, only: [:show]
  before_action :admin_user, except: [:new, :create, :edit, :update, :show]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_index_user]  
  before_action :set_users, only: :index
  before_action :set_one_month, only: :show

  def index
  end

  def update_index_user
    if @user.update_attributes(index_user_params)
      flash[:success] = "#{@user.name}の情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "#{@user.name}の情報の更新に失敗しました。" + @user.errors.full_messages.join("、")
      render :index
    end
  end

  def show
    @users_arry = superiors_users_of_arry
    @attendances_authentication_month = @attendances.first
    @authentication_attendances = Attendance.includes(:user).where(
      attendances_authentication_user: current_user.name,
      authentication_state_attendances: "申請中"
      )
    @edit_attendances = Attendance.includes(:user).where(
      edit_authentication_user: current_user.name,
      authentication_state_edit: "申請中"
      )
    @overwork_attendances = Attendance.includes(:user).where(
      overwork_authentication_user: current_user.name,
      authentication_state_overwork: "申請中"
      )
    output_user = User.find(params[:id]).name
    output_month = @attendances.first.worked_on.month
    respond_to  do |format|
      format.html
      format.csv do
        generate_csv(@attendances, output_user, output_month)
      end
    end
  end

  def import
    if params[:file].present?
      User.import(params[:file])
      flash[:success] = 'CSVファイルの読み込みに成功しました。'
      redirect_to users_path
    else
      flash[:danger] = 'CSVファイルを選択してください。'
      redirect_to users_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーを新規登録しました。'
      redirect_to current_user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      if current_user.admin
        redirect_to users_url
      else
        redirect_to current_user
      end
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_work_info
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :affiliation)
    end

    def index_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :affiliation,
        :employee_number, :uid, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end