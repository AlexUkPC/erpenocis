class RemovePaidAmountFromSupplierInvoice < ActiveRecord::Migration[6.1]
  def change
    remove_column :supplier_invoices, :paid_amount
  end
end
