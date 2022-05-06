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
require 'rails_helper'

RSpec.describe ExpenseValue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
