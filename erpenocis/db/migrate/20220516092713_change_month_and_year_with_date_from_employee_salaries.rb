class ChangeMonthAndYearWithDateFromEmployeeSalaries < ActiveRecord::Migration[6.1]
  def change
    remove_column :employee_salaries, :month, :integer
    remove_column :employee_salaries, :year, :integer
    add_column :employee_salaries, :date, :date
  end
end
