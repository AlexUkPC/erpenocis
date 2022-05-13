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
FactoryBot.define do
  factory :project_situation do
    advance_invoice_date { "2022-05-05" }
    advance_invoice_number { "MyString" }
    advance_payment_date { "2022-05-05" }
    advance_payment { "9.99" }
    advance_month { 1 }
    advance_year { 1 }
    closure_invoice_date { "2022-05-05" }
    closure_invoice_number { "MyString" }
    closure_payment_date { "2022-05-05" }
    closure_payment { "9.99" }
    closure_month { 1 }
    closure_year { 1 }
    project { nil }
  end
end
