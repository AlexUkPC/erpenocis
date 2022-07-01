# == Schema Information
#
# Table name: suppliers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Supplier < ApplicationRecord
  has_many :supplier_invoices, dependent: :destroy
  accepts_nested_attributes_for :supplier_invoices, reject_if: proc { |attributes| attributes['number'].blank? }, allow_destroy: true
  def self.accessible_attributes
    ["name"]
  end
end
