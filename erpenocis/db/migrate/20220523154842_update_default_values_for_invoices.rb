class UpdateDefaultValuesForInvoices < ActiveRecord::Migration[6.1]
  def change
    change_column :invoices, :invoice_value_without_vat, :decimal, precision: 15, scale: 2, default: 0
    change_column :invoices, :invoice_value_for_project_without_vat, :decimal, precision: 15, scale: 2, default: 0
  end
end
