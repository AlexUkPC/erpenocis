# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string
#  obs        :text
#  start_date :date
#  stoc       :boolean
#  value      :decimal(15, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
FactoryBot.define do
  factory :project do
    name { "MyString" }
    start_date { "2022-05-05" }
    end_date { "2022-05-05" }
    value { "9.99" }
    obs { "MyText" }
    stoc { false }
  end
end
