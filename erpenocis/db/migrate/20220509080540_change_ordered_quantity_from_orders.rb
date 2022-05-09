class ChangeOrderedQuantityFromOrders < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :ordered_quantity, :integer, default: 0
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
