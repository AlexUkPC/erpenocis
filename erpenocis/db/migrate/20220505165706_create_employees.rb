class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.date :hire_date
      t.date :dismiss_date

      t.timestamps
    end
  end
end
