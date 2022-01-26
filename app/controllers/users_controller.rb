class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]  
before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_work_info]  
before_action :admin_or_correct_user, only: :show
before_action :admin_user, only: [:index, :destroy, :edit_basic_work_info]
before_action :set_one_month, only: :show

  def index
    @users = User.all
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

  def list_of_employees
    @users = User.all.includes(:attendances)
  end

  def edit_basic_work_info
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :department,
        :employee_number, :uid, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    def set_user
      @user = User.find(params[:id])
    end
end