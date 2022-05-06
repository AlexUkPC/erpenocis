# == Schema Information
#
# Table name: supplier_invoices
#
#  id          :bigint           not null, primary key
#  date        :date
#  due_date    :date
#  number      :string
#  paid_amount :decimal(15, 2)
#  value       :decimal(15, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :bigint           not null
#
# Indexes
#
#  index_supplier_invoices_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (supplier_id => suppliers.id)
#
require 'rails_helper'

RSpec.describe SupplierInvoice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
