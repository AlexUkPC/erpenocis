# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  category         :string
#  cote             :string
#  delivery_date    :date
#  name_type_color  :string
#  needed_quantity  :integer
#  obs              :text
#  order_date       :date
#  ordered_quantity :integer
#  status           :integer
#  supplier_contact :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  brother_id       :string
#  project_id       :bigint           not null
#  supplier_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_project_id   (project_id)
#  index_orders_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (supplier_id => suppliers.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
