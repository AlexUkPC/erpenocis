class UpdateDefaultValuesForProjects < ActiveRecord::Migration[6.1]
  def change
    change_column :projects, :value, :decimal, precision: 15, scale: 2, default: 0
  end
end
