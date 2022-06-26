class EmployeeImportsController < ApplicationController
  def new
    @employee_import = EmployeeImport.new
    @employee_import.current_user = current_user
  end

  def create
    begin
      @employee_import = EmployeeImport.new(params[:employee_import])
      @employee_import.current_user = current_user
      if @employee_import.save
        redirect_to employees_path(current_tab: "to"), notice: "Imported employees successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end