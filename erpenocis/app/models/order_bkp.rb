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
#  ordered_quantity :integer          default(0)
#  status           :integer
#  supplier_contact :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  brother_id       :string
#  project_id       :bigint           not null
#  supplier_id      :bigint
#  user_id          :string
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
class Order < ApplicationRecord
  # belongs_to :supplier
  belongs_to :project
  # validates :supplier, presence: false
  enum status: [:necesar_materiale, :in_asteptare, :livrat, :intarziat, :anulat ]
  before_save :check_quantity
  private
  def check_quantity
    if self.ordered_quantity && self.ordered_quantity!=0 && self.needed_quantity>self.ordered_quantity
      self.needed_quantity = self.ordered_quantity
      self.status = 1
    end
  end
end
