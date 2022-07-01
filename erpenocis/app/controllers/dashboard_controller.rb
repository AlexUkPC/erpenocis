class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @orders = Order.dashboard_between_dates(params[:start_date] ? params[:start_date] : Date.parse("2020-01-01"),params[:end_date] ? params[:end_date] : Date.today).order("id DESC")
    @users = User.all
    @suppliers = Supplier.all
    @orders_last_30 = Order.where("created_at >= ? AND created_at <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).count
    @invoices_last_30 = Invoice.where("created_at >= ? AND created_at <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).count
    @projects_last_30 = Project.where("created_at >= ? AND created_at <= ? AND stoc = false",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).count
    @profit_last_30 = Project.where("created_at >= ? AND created_at <= ? AND stoc = false",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:value) - Invoice.where("created_at >= ? AND created_at <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:invoice_value_for_project_without_vat)
    @employee_salaries = EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:net_salary) + EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:salary_tax) + EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:meal_vouchers) + EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:gift_vouchers) + EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:overtime) + EmployeeSalary.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).sum(:extra_salary)
    @administrative = ExpenseValue.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).where(expense_id: Expense.where("expense_type = 0").map.to_a).sum(:value)
    @financiare = ExpenseValue.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).where(expense_id: Expense.where("expense_type = 1").map.to_a).sum(:value)
    @investitii = ExpenseValue.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).where(expense_id: Expense.where("expense_type = 2").map.to_a).sum(:value)
    @alte_cheltuieli = ExpenseValue.where("date >= ? AND date <= ?",params[:start_date] || Date.today-1.month,params[:end_date] || Date.today).where(expense_id: Expense.where("expense_type = 3").map.to_a).sum(:value)
    @indirect_expenses = @employee_salaries + @administrative + @financiare + @investitii + @alte_cheltuieli
    @suppliers = Supplier.all
  end
end
