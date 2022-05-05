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
class Invoice < ApplicationRecord
  belongs_to :project
end
