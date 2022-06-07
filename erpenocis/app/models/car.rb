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
  scope :between_dates, lambda {|start_date, end_date| where("(rca_expiry_date >= ? AND rca_expiry_date <= ? OR rov_expiry_date >= ? AND rov_expiry_date <= ? OR itp_expiry_date >= ? AND itp_expiry_date <= ?) OR (rca_expiry_date IS null AND rov_expiry_date IS null AND itp_expiry_date IS null)", start_date, end_date, start_date, end_date, start_date, end_date )}
  validate :after_01_01_2020

  def after_01_01_2020
    if rca_expiry_date.present? && rca_expiry_date<Date.parse('2020.01.01')
      errors.add(:rca_expiry_date, "nu poate fi inainte de 01.01.2020")
    end
    if rov_expiry_date.present? && rov_expiry_date<Date.parse('2020.01.01')
      errors.add(:rov_expiry_date, "nu poate fi inainte de 01.01.2020")
    end
    if itp_expiry_date.present? && itp_expiry_date<Date.parse('2020.01.01')
      errors.add(:itp_expiry_date, "nu poate fi inainte de 01.01.2020")
    end
  end
  def self.accessible_attributes
    ["number_plate", "rca_expiry_date", "rov_expiry_date", "itp_expiry_date"]
  end
end
