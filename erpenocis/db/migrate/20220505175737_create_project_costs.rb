class CreateProjectCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :project_costs do |t|
      t.decimal :amount, precision: 15, scale: 2
      t.integer :month
      t.integer :year
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
