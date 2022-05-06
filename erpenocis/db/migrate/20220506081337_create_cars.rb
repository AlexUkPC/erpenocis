class CreateCars < ActiveRecord::Migration[6.1]
  def change
    create_table :cars do |t|
      t.string :number_plate
      t.date :rca_expiry_date
      t.date :rov_expiry_date
      t.date :itp_expiry_date

      t.timestamps
    end
  end
end
