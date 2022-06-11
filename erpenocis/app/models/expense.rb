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
  has_many :expense_values, dependent: :destroy
  enum expense_type: [:administrative, :financiare, :investitii, :alte_cheltuieli]
  accepts_nested_attributes_for :expense_values, reject_if: proc { |attributes| attributes['value'].blank? }, allow_destroy: true
  scope :created_between, lambda {|start_date, end_date| where("date IS NULL OR date >= ? AND date <= ?", start_date, end_date )}
  def self.accessible_attributes
    ["name", "expense_type"]
  end
end
