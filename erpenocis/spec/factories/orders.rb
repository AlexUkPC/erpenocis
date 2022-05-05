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
FactoryBot.define do
  factory :order do
    status { 1 }
    category { "MyString" }
    name_type_color { "MyString" }
    needed_quantity { 1 }
    unit { "MyString" }
    cote { "MyString" }
    brother_id { "MyString" }
    ordered_quantity { 1 }
    supplier { nil }
    supplier_contact { "MyString" }
    order_date { "2022-05-05" }
    delivery_date { "2022-05-05" }
    obs { "MyText" }
    project { nil }
  end
end
