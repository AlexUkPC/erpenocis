class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :description
      t.string :category
      t.string :supplier
      t.string :invoice_number
      t.date :invoice_date
      t.decimal :invoice_value_without_vat, precision: 15, scale: 2
      t.decimal :invoice_value_for_project_without_vat, precision: 15, scale: 2
      t.string :code
      t.text :obs
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
