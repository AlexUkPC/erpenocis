class StockController < ApplicationController
  def index
    @projects = Project.where(stoc: true)
    @users = User.all
  end

end
