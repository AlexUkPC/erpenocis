class IndirectExpensesController < ApplicationController
  before_action :set_dates_params, :set_table_head
  def index
    @employee_salaries = EmployeeSalary.all
    @expense_types = Expense.expense_types.keys
  end
end
