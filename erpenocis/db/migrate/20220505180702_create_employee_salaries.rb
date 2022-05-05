class CreateEmployeeSalaries < ActiveRecord::Migration[6.1]
  def change
    create_table :employee_salaries do |t|
      t.decimal :net_salary, precision: 15, scale: 2
      t.decimal :salary_tax, precision: 15, scale: 2
      t.date :salary_tax_due_date
      t.decimal :meal_vouchers, precision: 15, scale: 2
      t.decimal :gift_vouchers, precision: 15, scale: 2
      t.decimal :overtime, precision: 15, scale: 2
      t.decimal :extra_salary, precision: 15, scale: 2
      t.integer :month
      t.integer :year
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
