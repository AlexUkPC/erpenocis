# == Schema Information
#
# Table name: january_solds
#
#  id         :bigint           not null, primary key
#  value      :decimal(15, 2)   default(0.0)
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe JanuarySold, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
