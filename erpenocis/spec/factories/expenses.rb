# == Schema Information
#
# Table name: expenses
#
#  id           :bigint           not null, primary key
#  expense_type :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :expense do
    name { "MyString" }
    type { 1 }
  end
end
