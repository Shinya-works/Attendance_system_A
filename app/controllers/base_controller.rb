class BaseController < ApplicationController
  before_action :set_base, only: [:edit, :update, :destroy]  
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_work_info]  
  before_action :admin_or_correct_user, only: :show
  before_action :admin_user, only: [:index, :destroy, :edit_basic_work_info]

  def index
    @bases = Base.all
  end

  def new
    @base = Bases.new
  end

  def create
    if @base.save
      flash[:success] = "拠点情報の作成に成功しました"
      redirect_to bases_path
    else
      flash[:danger] = "拠点情報の作成に失敗しました"
      render 'new'
    end
  end
  

  def edit
  end

  def update
    if @base.update_attributes(base_params])
      flash[:success] = "拠点情報の更新に成功しました"
      redirect_to @object
    else
      flash[:danger] = "拠点情報の更新に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @base.destroy
    flash[:success] = "#{@base.name}のデータを削除しました。"
    redirect_to bases_url
  end

  private

    def set_base
      @base = Base.find(params[:id])
    end

    def base_params
      params.require(:base).parmit(:base_number, :base_name, :time_type)
    end
  
  
  
end
