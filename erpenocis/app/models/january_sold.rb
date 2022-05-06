# == Schema Information
#
# Table name: january_solds
#
#  id           :bigint           not null, primary key
#  january_sold :decimal(15, 2)
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class JanuarySold < ApplicationRecord
end
