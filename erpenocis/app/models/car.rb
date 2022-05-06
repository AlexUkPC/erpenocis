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
class Car < ApplicationRecord
end
