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
require 'rails_helper'

RSpec.describe ProjectCost, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
