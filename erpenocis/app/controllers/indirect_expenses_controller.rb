class IndirectExpensesController < ApplicationController
  before_action :set_dates_params, :set_table_head
  def index
    @total_per_months = []
    @months.times do |month|
      @total_per_months[month] = 0 
    end
    @employee_salaries = EmployeeSalary.all
    @expense_types = Expense.expense_types.keys
  end
end
