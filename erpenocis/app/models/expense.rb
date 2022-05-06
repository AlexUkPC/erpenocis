# == Schema Information
#
# Table name: expenses
#
#  id           :bigint           not null, primary key
#  expense_type :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Expense < ApplicationRecord
  has_many :expense_values
end
