class ChangeDefaultValuesFromProjectSituation < ActiveRecord::Migration[6.1]
  def change
    change_column :project_situations, :advance_payment, :decimal, precision: 15, scale: 2, default: 0
    change_column :project_situations, :closure_payment, :decimal, precision: 15, scale: 2, default: 0
    change_column :project_situations, :advance_invoice_date, :date, default: ""
    change_column :project_situations, :advance_payment_date, :date, default: ""
    change_column :project_situations, :closure_invoice_date, :date, default: ""
    change_column :project_situations, :closure_payment_date, :date, default: ""
  end
end
