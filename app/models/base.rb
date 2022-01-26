class Base < ApplicationRecord
  def index

  end

  def new
  end

  def create

  end

  def edit

  end
  
  def update
    if @object.update_attributes(params[:object])
    flash[:success] = "拠点情報の更新に成功しました"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報の更新に失敗しました"
      render 'edit'
    end
  end
  
  
end
