class AddModelIdToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :model_id, :integer
  end
end
