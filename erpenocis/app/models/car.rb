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
  scope :between_dates, lambda {|start_date, end_date| where("rca_expiry_date >= ? AND rca_expiry_date <= ? OR rov_expiry_date >= ? AND rov_expiry_date <= ? OR itp_expiry_date >= ? AND itp_expiry_date <= ?", start_date, end_date, start_date, end_date, start_date, end_date )}
end
