class ProjectSituationImportsController < ApplicationController
  def new
    @project_situation_import = ProjectSituationImport.new
  end

  def create
    begin
      @project_situation_import = ProjectSituationImport.new(params[:project_situation_import])
      if @project_situation_import.save
        redirect_to project_situations_url, notice: "Imported project situations successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end