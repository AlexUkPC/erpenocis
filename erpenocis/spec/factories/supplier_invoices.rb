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
FactoryBot.define do
  factory :supplier_invoice do
    number { "MyString" }
    value { "9.99" }
    paid_amount { "MyString" }
    date { "2022-05-06" }
    due_date { "2022-05-06" }
    supplier { nil }
  end
end
