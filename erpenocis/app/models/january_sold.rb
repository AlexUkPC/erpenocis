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
class JanuarySold < ApplicationRecord
  validates :year, uniqueness: { message: "Ai setat deja soldul pentru ianuarie pe acest an" }
end
