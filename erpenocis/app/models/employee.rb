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
class Employee < ApplicationRecord
  has_many :employee_salaries, dependent: :destroy
  accepts_nested_attributes_for :employee_salaries, reject_if: proc { |attributes| attributes['net_salary'].blank? }, allow_destroy: true
  def self.accessible_attributes
    ["name", "hire_date", "dismiss_date"]
  end
end
