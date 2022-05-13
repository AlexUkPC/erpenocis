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
#  user_id    :string
#
class Project < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :project_situation, dependent: :destroy
  has_many :project_costs, dependent: :destroy
  def ord
    if self.stoc
      Order.where(project_id: self.id).order("id ASC")
    else
      Order.where(ordered_quantity: 0, project_id: self.id).order("id ASC") 
    end

    # Order.where(if !self.stoc then (ordered_quantity: 0) end, project_id: self.id).order("id ASC")
  end
end
