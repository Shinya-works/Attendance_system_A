class BasesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_base, only: [:edit, :update, :destroy]  

  def index
    @bases = Base.all
  end

  def new
    @base = Base.new
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報の作成に成功しました"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の作成に失敗しました"
      render 'new'
    end
  end
  

  def edit
  end

  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報の更新に成功しました"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の更新に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to bases_url
  end

  private

    def set_base
      @base = Base.find(params[:id])
    end

    def base_params
      params.require(:base).permit(:base_number, :base_name, :time_type)
    end
  
  
  
end
