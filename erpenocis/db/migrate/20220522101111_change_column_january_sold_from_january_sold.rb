class ChangeColumnJanuarySoldFromJanuarySold < ActiveRecord::Migration[6.1]
  def change
    remove_column :january_solds, :january_sold, :decimal, precision: 15, scale: 2, default: 0
    add_column :january_solds, :value, :decimal, precision: 15, scale: 2, default: 0
  end
end
