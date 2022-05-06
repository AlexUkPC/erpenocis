# == Schema Information
#
# Table name: expense_values
#
#  id         :bigint           not null, primary key
#  date       :date
#  due_date   :date
#  value      :decimal(, )
#  vat_taxes  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  expense_id :bigint           not null
#
# Indexes
#
#  index_expense_values_on_expense_id  (expense_id)
#
# Foreign Keys
#
#  fk_rails_...  (expense_id => expenses.id)
#
FactoryBot.define do
  factory :expense_value do
    value { "9.99" }
    date { "2022-05-06" }
    due_date { "2022-05-06" }
    vat_taxes { false }
    expense { nil }
  end
end
