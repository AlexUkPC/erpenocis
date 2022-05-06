class CreateExpenseValues < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_values do |t|
      t.decimal :value, precision: 15, scale: 2
      t.date :date
      t.date :due_date
      t.boolean :vat_taxes
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
