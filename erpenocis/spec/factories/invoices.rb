# == Schema Information
#
# Table name: invoices
#
#  id                                    :bigint           not null, primary key
#  category                              :string
#  code                                  :string
#  description                           :string
#  invoice_date                          :date
#  invoice_number                        :string
#  invoice_value_for_project_without_vat :decimal(15, 2)
#  invoice_value_without_vat             :decimal(15, 2)
#  obs                                   :text
#  supplier                              :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  project_id                            :bigint           not null
#
# Indexes
#
#  index_invoices_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
FactoryBot.define do
  factory :invoice do
    description { "MyString" }
    category { "MyString" }
    supplier { "MyString" }
    invoice_number { "MyString" }
    invoice_date { "2022-05-05" }
    invoice_value_without_vat { "9.99" }
    invoice_value_for_project_without_vat { "9.99" }
    code { "MyString" }
    obs { "MyText" }
    project { nil }
  end
end
