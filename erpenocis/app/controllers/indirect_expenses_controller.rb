class IndirectExpensesController < ApplicationController
  def index
    @start_month = params[:start_month].to_i
    @start_year = params[:start_year].to_i
    @end_month = params[:end_month].to_i
    @end_year = params[:end_year].to_i
    @months = (@end_year - @start_year) * 12 + @end_month - @start_month + 1
    @employee_salaries = EmployeeSalary.all
    @expense_types = Expense.expense_types.keys
  end
end
