class ChangeSupplierToOrders < ActiveRecord::Migration[6.1]
  def change
    remove_reference :orders, :supplier, null: false, foreign_key: true
    add_reference :orders, :supplier, null: true, foreign_key: true
  end
end
