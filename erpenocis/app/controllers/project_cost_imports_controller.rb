class ProjectCostImportsController < ApplicationController
  def new
    @project_cost_import = ProjectCostImport.new
  end

  def create
    begin
      @project_cost_import = ProjectCostImport.new(params[:project_cost_import])
      if @project_cost_import.save
        redirect_to project_costs_url, notice: "Imported project costs successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end