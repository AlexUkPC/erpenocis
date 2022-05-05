# == Schema Information
#
# Table name: employees
#
#  id           :bigint           not null, primary key
#  dismiss_date :date
#  hire_date    :date
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :employee do
    name { "MyString" }
    hire_date { "2022-05-05" }
    dismiss_date { "2022-05-05" }
  end
end
