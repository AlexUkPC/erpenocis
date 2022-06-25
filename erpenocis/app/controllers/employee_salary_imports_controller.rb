class EmployeeSalaryImportsController < ApplicationController
  def new
    @employee_salary_import = EmployeeSalaryImport.new
    @employee_salary_import.current_user = current_user
  end

  def create
    begin
      @employee_salary_import = EmployeeSalaryImport.new(params[:employee_salary_import])
      @employee_salary_import.current_user = current_user
      if @employee_salary_import.save
        redirect_to employees_path(current_tab: "to"), notice: "Imported employee salaries successfully."
      else
        render :new
      end
    rescue => exception
      render :action => 'new', status: :unprocessable_entity
    end
    
  end
end