# == Schema Information
#
# Table name: expense_values
#
#  id         :bigint           not null, primary key
#  date       :date
#  due_date   :date
#  value      :decimal(15, 2)
#  vat_taxes  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  expense_id :bigint           not null
#
# Indexes
#
#  index_expense_values_on_expense_id  (expense_id)
#
# Foreign Keys
#
#  fk_rails_...  (expense_id => expenses.id)
#
class ExpenseValue < ApplicationRecord
  belongs_to :expense
  scope :created_between, lambda {|start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date )}
  def self.accessible_attributes
    ["date", "value"]
  end
end
