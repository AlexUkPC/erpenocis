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
  validates :ordered_quantity, presence: true
  enum status: [:necesar_materiale, :in_asteptare, :livrat, :intarziat, :anulat ]
  before_save :check_quantity
  scope :between_dates, lambda {|start_date, end_date| where("order_date IS null OR order_date >= ? AND order_date <= ?", start_date, end_date )}

  def full_description
  "Categorie:" +  self.category + " Denumire/Tip/Nuanta:" + self.name_type_color + " Cantitate necesara:" + self.needed_quantity.to_s + " UM:" + self.unit + " Cote:" + self.cote
  end
  private
  def check_quantity
    if self.ordered_quantity!=0 
      if self.needed_quantity>self.ordered_quantity
        self.needed_quantity = self.ordered_quantity
      end
      self.status == "necesar_materiale" ? self.status = 1 : ""
    # else
    #   self.status = 0
    end
    
  end
  
end
