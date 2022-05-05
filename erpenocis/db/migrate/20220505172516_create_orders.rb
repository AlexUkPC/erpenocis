class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status
      t.string :category
      t.string :name_type_color
      t.integer :needed_quantity
      t.string :unit
      t.string :cote
      t.string :brother_id
      t.integer :ordered_quantity
      t.references :supplier, null: false, foreign_key: true
      t.string :supplier_contact
      t.date :order_date
      t.date :delivery_date
      t.text :obs
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
