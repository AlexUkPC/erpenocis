class StockController < ApplicationController
  def index
    @projects = Project.where(stoc: true).order("id DESC")
    @users = User.all
  end

end
