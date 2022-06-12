# == Schema Information
#
# Table name: supplier_invoices
#
#  id          :bigint           not null, primary key
#  date        :date
#  due_date    :date
#  number      :string
#  value       :decimal(15, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :bigint           not null
#
# Indexes
#
#  index_supplier_invoices_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (supplier_id => suppliers.id)
#
class SupplierInvoice < ApplicationRecord
  belongs_to :supplier
  has_many :supplier_invoice_payments, dependent: :destroy
  accepts_nested_attributes_for :supplier_invoice_payments, reject_if: :all_blank, allow_destroy: true
  scope :created_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
  scope :created_between_due_date, lambda {|start_date, end_date| where("due_date >= ? AND due_date <= ?", start_date, end_date )}
  def self.accessible_attributes
    ["number", "value", "date", "due_date"]
  end
end
