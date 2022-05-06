# == Schema Information
#
# Table name: cars
#
#  id              :bigint           not null, primary key
#  itp_expiry_date :date
#  number_plate    :string
#  rca_expiry_date :date
#  rov_expiry_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :car do
    number_plate { "MyString" }
    rca_expiry_date { "2022-05-06" }
    rov_expiry_date { "2022-05-06" }
    itp_expiry_date { "2022-05-06" }
  end
end
