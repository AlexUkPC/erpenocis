class CreateJanuarySolds < ActiveRecord::Migration[6.1]
  def change
    create_table :january_solds do |t|
      t.decimal :january_sold, precision: 15, scale: 2
      t.integer :year

      t.timestamps
    end
  end
end
