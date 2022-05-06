class StockController < ApplicationController
  def index
    @projects = Project.where(stoc: true)
  end
end
