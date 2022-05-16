class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  # GET /employees or /employees.json
  def index
    employee_id = params[:employee_id]
    employee_salary_id = params[:employee_salary_id]
    employee_salary = params[:employee_salary]
    @start_month = params[:start_month].to_i
    @start_year = params[:start_year].to_i
    @end_month = params[:end_month].to_i
    @end_year = params[:end_year].to_i
    @months = (@end_year - @start_year) * 12 + @end_month - @start_month + 1
    @employee_salariess = {}
    if employee_salary
      @employee_salary = EmployeeSalary.new(date: "01/"+params[:current_month]+"/"+params[:current_year])
    end
    @employees = Employee.all.order("id ASC")
    if !employee_id.nil?
      @employee = Employee.find(employee_id)
      if !employee_salary_id.nil?
        @employee_salary = EmployeeSalary.find(employee_salary_id)
      end 
    else
      @employee = Employee.new()
    end
    @employee.employee_salaries.build
    @employee_salaries = EmployeeSalary.where(employee_id: @employees.ids)

  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path(start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Employee was successfully created." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employees_path(start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Employee was successfully updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_path(start_month: params[:start_month], start_year: params[:start_year], end_month: params[:end_month], end_year: params[:end_year]), notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:name, :hire_date, :dismiss_date, employee_salaries_attributes: [:id, :net_salary, :salary_tax, :salary_tax_due_date, :meal_vouchers, :gift_vouchers, :overtime, :extra_salary, :date, :_destroy])
    end
end
