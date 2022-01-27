class BaseController < ApplicationController

  def index
    @bases = Base.all
  end

  def new
    @base = Bases.new
  end

  def def create
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

  def delete
  end
  
end
