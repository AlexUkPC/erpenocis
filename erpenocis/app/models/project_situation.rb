# == Schema Information
#
# Table name: project_situations
#
#  id                     :bigint           not null, primary key
#  advance_invoice_date   :date
#  advance_invoice_number :string
#  advance_month          :integer
#  advance_payment        :decimal(15, 2)   default(0.0)
#  advance_payment_date   :date
#  advance_year           :integer
#  closure_invoice_date   :date
#  closure_invoice_number :string
#  closure_month          :integer
#  closure_payment        :decimal(15, 2)   default(0.0)
#  closure_payment_date   :date
#  closure_year           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  project_id             :bigint           not null
#
# Indexes
#
#  index_project_situations_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectSituation < ApplicationRecord
  belongs_to :project
end
