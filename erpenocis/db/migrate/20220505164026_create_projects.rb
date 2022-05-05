class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.decimal :value, precision: 15, scale: 2
      t.text :obs
      t.boolean :stoc

      t.timestamps
    end
  end
end
