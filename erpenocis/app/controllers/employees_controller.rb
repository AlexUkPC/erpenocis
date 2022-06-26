class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_current_tab
  before_action :set_dates_params, :set_table_head

  # GET /employees or /employees.json
  def index
    employee_id = params[:employee_id]
    employee_salary_id = params[:employee_salary_id]
    employee_salary = params[:employee_salary]
    @employee_salariess = {}
    if employee_salary
      @employee_salary = EmployeeSalary.new(date: "01/"+params[:current_month]+"/"+params[:current_year])
    end
    
    @employees = Employee.eager_load(:employee_salaries).order("employees.id ASC, employee_salaries.date ASC")
    
    if !employee_id.nil?
      @employee = Employee.find(employee_id)
      if !employee_salary_id.nil?
        @employee_salary = EmployeeSalary.find(employee_salary_id)
      end 
    else
      @employee = Employee.new(hire_date: Date.today)
    end
    @employee.employee_salaries.build(date: Date.today)
    # @employee_salaries = EmployeeSalary.where(employee_id: @employees.ids)

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
        employee_salary = employee_params[:employee_salaries_attributes]["0"]
        Record.create(record_type: "Adaugare", location: "Cheltuieli salariale", model_id: @employee.id, initial_data: "", modified_data: "Nume: #{@employee.name} | Data angajarii: #{@employee.hire_date} | Data incheierii: #{@employee.dismiss_date} | Salariu net: #{employee_salary[:net_salary]} | Taxe de achitat: #{employee_salary[:salary_tax]} | Data scadenta taxe: #{employee_salary[:salary_tax_due_date]} | Bonuri de masa: #{employee_salary[:meal_vouchers]} | Bonuri cadou: #{employee_salary[:gift_vouchers]} | Ore suplimentare: #{employee_salary[:overtime]} | Salariu extra: #{employee_salary[:extra_salary]} | Data: #{employee_salary[:date]}", user_id: current_user.id)
        format.html { redirect_to employees_path(current_tab: @current_tab, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Employee was successfully created." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    @old_info_employee = @employee.dup
    @old_info_employee_salary = @employee.employee_salaries.find_by_id(employee_params[:employee_salaries_attributes]["0"][:id])
    respond_to do |format|
      if @employee.update(employee_params)
        old_s = ""
        s = ""
        if @old_info_employee.name != @employee.name
          old_s += "Nume angajat: #{@old_info_employee.name} | "
          s += "Nume angajat: #{@employee.name} | "
        end
        if @old_info_employee.hire_date != @employee.hire_date
          old_s += "Data angajarii: #{@old_info_employee.hire_date} | "
          s += "Data angajarii: #{@employee.hire_date} | "
        end
        if @old_info_employee.dismiss_date != @employee.dismiss_date
          old_s += "Data incheierii: #{@old_info_employee.dismiss_date} | "
          s += "Data incheierii: #{@employee.dismiss_date} | "
        end
        if s!="" || old_s != ""
          Record.create(record_type: "Modificare", location: "Cheltuieli salariale", model_id: @employee.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
        end
        if employee_params[:employee_salaries_attributes]["0"][:id]
          @employee_salary = @employee.employee_salaries.find_by_id(employee_params[:employee_salaries_attributes]["0"][:id])
          old_s = ""
          s = ""
          if @old_info_employee_salary.net_salary != @employee_salary.net_salary
            old_s += "Salariu net: #{@old_info_employee_salary.net_salary} | "
            s += "Salariu net: #{@employee_salary.net_salary} | "
          end
          if @old_info_employee_salary.salary_tax != @employee_salary.salary_tax
            old_s += "Taxe de achitat: #{@old_info_employee_salary.salary_tax} | "
            s += "Taxe de achitat: #{@employee_salary.salary_tax} | "
          end
          if @old_info_employee_salary.salary_tax_due_date != @employee_salary.salary_tax_due_date
            old_s += "Data scadenta taxe: #{@old_info_employee_salary.salary_tax_due_date} | "
            s += "Data scadenta taxe: #{@employee_salary.salary_tax_due_date} | "
          end
          if @old_info_employee_salary.meal_vouchers != @employee_salary.meal_vouchers
            old_s += "Bonuri de masa: #{@old_info_employee_salary.meal_vouchers} | "
            s += "Bonuri de masa: #{@employee_salary.meal_vouchers} | "
          end
          if @old_info_employee_salary.gift_vouchers != @employee_salary.gift_vouchers
            old_s += "Bonuri cadou: #{@old_info_employee_salary.gift_vouchers} | "
            s += "Bonuri cadou: #{@employee_salary.gift_vouchers} | "
          end
          if @old_info_employee_salary.overtime != @employee_salary.overtime
            old_s += "Ore suplimentare: #{@old_info_employee_salary.overtime} | "
            s += "Ore suplimentare: #{@employee_salary.overtime} | "
          end
          if @old_info_employee_salary.extra_salary != @employee_salary.extra_salary
            old_s += "Salariu extra: #{@old_info_employee_salary.extra_salary} | "
            s += "Salariu extra: #{@employee_salary.extra_salary} | "
          end
          if @old_info_employee_salary.date != @employee_salary.date
            old_s += "Data: #{@old_info_employee_salary.date} | "
            s += "Data: #{@employee_salary.date} | "
          end
          if s!="" || old_s != ""
            Record.create(record_type: "Modificare", location: "Cheltuieli salariale", model_id: @employee.id, initial_data: old_s[0..-3], modified_data: s[0..-3], user_id: current_user.id)
          end
        else
          employee_salary = employee_params[:employee_salaries_attributes]["0"]
          Record.create(record_type: "Adaugare", location: "Cheltuieli salariale", model_id: @employee.id, initial_data: "", modified_data: "Salariu net: #{employee_salary[:net_salary]} | Taxe de achitat: #{employee_salary[:salary_tax]} | Data scadenta taxe: #{employee_salary[:salary_tax_due_date]} | Bonuri de masa: #{employee_salary[:meal_vouchers]} | Bonuri cadou: #{employee_salary[:gift_vouchers]} | Ore suplimentare: #{employee_salary[:overtime]} | Salariu extra: #{employee_salary[:extra_salary]} | Data: #{employee_salary[:date]}", user_id: current_user.id)
        end
        format.html { redirect_to employees_path(current_tab: @current_tab, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Employee was successfully updated." }
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
    Record.create(record_type: "Stergere", location: "Cheltuieli salariale", model_id: @employee.id, initial_data: "Nume: #{@employee.name} | Data angajarii: #{@employee.hire_date} | Data incheierii: #{@employee.dismiss_date}", modified_data: "", user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to employees_path(current_tab: @current_tab, sm: @start_month, sy: @start_year, em: @end_month, ey: @end_year), notice: "Employee was successfully destroyed." }
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
