# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string
#  obs        :text
#  start_date :date
#  stoc       :boolean
#  value      :decimal(15, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Project < ApplicationRecord
  has_many :orders
end
