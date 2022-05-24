# == Schema Information
#
# Table name: project_costs
#
#  id         :bigint           not null, primary key
#  amount     :decimal(15, 2)
#  month      :integer
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_project_costs_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectCost < ApplicationRecord
  belongs_to :project
  scope :between_dates, lambda {|start_month, end_month, start_year, end_year| where("month IS null OR year IS null OR month >= ? AND month <= ? AND year >= ? AND year <= ?", start_month, end_month, start_year, end_year )}
end
