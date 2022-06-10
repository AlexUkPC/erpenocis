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
  scope :between_advance_dates, lambda {|start_month, end_month, start_year, end_year| where("advance_month IS null OR advance_year IS null OR advance_month >= ? AND advance_month <= ? AND advance_year >= ? AND advance_year <= ?", start_month, end_month, start_year, end_year )}
  scope :between_closure_dates, lambda {|start_month, end_month, start_year, end_year| where("closure_month IS null OR closure_year IS null OR closure_month >= ? AND closure_month <= ? AND closure_year >= ? AND closure_year <= ?", start_month, end_month, start_year, end_year )}
  def self.accessible_attributes
    ["advance_invoice_date", "advance_invoice_number", "advance_payment_date", "advance_payment", "advance_month", "advance_year", "closure_invoice_date", "closure_invoice_number", "closure_payment_date", "closure_payment", "closure_month", "closure_year"]
  end
end
