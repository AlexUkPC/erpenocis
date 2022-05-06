class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :record_type
      t.string :location
      t.string :initial_data
      t.string :modified_data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
