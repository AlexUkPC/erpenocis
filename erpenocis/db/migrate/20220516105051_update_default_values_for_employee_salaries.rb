class UpdateDefaultValuesForEmployeeSalaries < ActiveRecord::Migration[6.1]
  def change
    change_column :employee_salaries, :net_salary, :decimal, precision: 15, scale: 2, default: 0
    change_column :employee_salaries, :salary_tax, :decimal, precision: 15, scale: 2, default: 0
    change_column :employee_salaries, :meal_vouchers, :decimal, precision: 15, scale: 2, default: 0
    change_column :employee_salaries, :gift_vouchers, :decimal, precision: 15, scale: 2, default: 0
    change_column :employee_salaries, :overtime, :decimal, precision: 15, scale: 2, default: 0
    change_column :employee_salaries, :extra_salary, :decimal, precision: 15, scale: 2, default: 0
  end
end
