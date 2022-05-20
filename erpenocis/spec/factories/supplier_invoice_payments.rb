# == Schema Information
#
# Table name: supplier_invoice_payments
#
#  id                  :bigint           not null, primary key
#  date                :date
#  paid_amount         :decimal(15, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  supplier_invoice_id :bigint           not null
#
# Indexes
#
#  index_supplier_invoice_payments_on_supplier_invoice_id  (supplier_invoice_id)
#
# Foreign Keys
#
#  fk_rails_...  (supplier_invoice_id => supplier_invoices.id)
#
FactoryBot.define do
  factory :supplier_invoice_payment do
    paid_amount { "9.99" }
    date { "2022-05-18" }
    supplier_invoice { nil }
  end
end
