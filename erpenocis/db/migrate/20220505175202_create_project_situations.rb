class CreateProjectSituations < ActiveRecord::Migration[6.1]
  def change
    create_table :project_situations do |t|
      t.date :advance_invoice_date
      t.string :advance_invoice_number
      t.date :advance_payment_date
      t.decimal :advance_payment, precision: 15, scale: 2
      t.integer :advance_month
      t.integer :advance_year
      t.date :closure_invoice_date
      t.string :closure_invoice_number
      t.date :closure_payment_date
      t.decimal :closure_payment, precision: 15, scale: 2
      t.integer :closure_month
      t.integer :closure_year
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
