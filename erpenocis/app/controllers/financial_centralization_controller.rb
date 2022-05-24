class FinancialCentralizationController < ApplicationController
  before_action :set_january_sold, only: %i[ update destroy ]
  before_action :set_dates_params, :set_table_head
  def index
    @projects = Project.where(stoc: false)
    @project_costs = ProjectCost.all
    @employee_salaries = EmployeeSalary.all
    @expense_values = ExpenseValue.all
    @project_situations = ProjectSituation.all
    @january_solds = JanuarySold.all
    @last_january_sold = @january_solds.where("year <= #{@start_year}").order("year ASC").last
    @last_january_sold = JanuarySold.new(value: 0, year: 2021) if !@last_january_sold
    @january_solds = JanuarySold.new(value: 0, year: 2021) if !@january_solds
    @months_before = (@start_year - @last_january_sold.year) * 12 + @start_month - 1
    if params[:jsid]!=""
      @january_sold = JanuarySold.find(params[:jsid])
    else
      @january_sold = JanuarySold.new
    end
  end
end
