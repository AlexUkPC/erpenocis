class ProjectImportsController < ApplicationController
  def new
    @project_import = ProjectImport.new
    @project_import.current_user = current_user
  end

  def create
    begin
      @project_import = ProjectImport.new(params[:project_import])
      @project_import.current_user = current_user
      if @project_import.save
        redirect_to projects_url, notice: "Imported projects successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end