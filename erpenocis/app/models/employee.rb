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
end
