# == Schema Information
#
# Table name: employee_salaries
#
#  id                  :bigint           not null, primary key
#  date                :date
#  extra_salary        :decimal(15, 2)   default(0.0)
#  gift_vouchers       :decimal(15, 2)   default(0.0)
#  meal_vouchers       :decimal(15, 2)   default(0.0)
#  net_salary          :decimal(15, 2)   default(0.0)
#  overtime            :decimal(15, 2)   default(0.0)
#  salary_tax          :decimal(15, 2)   default(0.0)
#  salary_tax_due_date :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  employee_id         :bigint           not null
#
# Indexes
#
#  index_employee_salaries_on_employee_id  (employee_id)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id)
#
require 'rails_helper'

RSpec.describe EmployeeSalary, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
