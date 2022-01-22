class BaseController < ApplicationController

  def index
    @bases = Base.all
  end
end
