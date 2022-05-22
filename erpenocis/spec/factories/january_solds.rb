# == Schema Information
#
# Table name: january_solds
#
#  id         :bigint           not null, primary key
#  value      :decimal(15, 2)   default(0.0)
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :january_sold do
    january_sold { "9.99" }
    year { 1 }
  end
end
