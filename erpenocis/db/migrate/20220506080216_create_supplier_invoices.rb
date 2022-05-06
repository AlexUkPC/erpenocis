class CreateSupplierInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :supplier_invoices do |t|
      t.string :number
      t.decimal :value, precision: 15, scale: 2
      t.decimal :paid_amount, precision: 15, scale: 2
      t.date :date
      t.date :due_date
      t.references :supplier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
