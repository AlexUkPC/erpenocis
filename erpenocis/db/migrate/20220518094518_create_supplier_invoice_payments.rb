class CreateSupplierInvoicePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :supplier_invoice_payments do |t|
      t.decimal :paid_amount, precision: 15, scale: 2
      t.date :date
      t.belongs_to :supplier_invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
