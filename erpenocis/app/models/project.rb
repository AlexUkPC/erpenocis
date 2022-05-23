# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string
#  obs        :text
#  start_date :date
#  stoc       :boolean
#  value      :decimal(15, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
class Project < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :project_situation, dependent: :destroy
  has_many :project_costs, dependent: :destroy
  validates :start_date, presence: true
  validate :after_01_01_2020
  validate :start_date_before_end_date
  
  accepts_nested_attributes_for :project_costs, reject_if: :all_blank, allow_destroy: true
  scope :between_dates, lambda {|start_date, end_date| where("start_date >= ? AND start_date <= ?", start_date, end_date )}
  scope :created_between, lambda {|start_date, end_date| where("start_date >= ? AND start_date <= ?", start_date, end_date )}

  def after_01_01_2020
    if start_date.present? && start_date<Date.parse('2020.01.01')
      errors.add(:start_date, "nu poate fi inainte de 2020")
    end
  end

  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date>end_date
      errors.add(:end_date, "nu poate fi inainte de data de inceput")
    end
  end
  
  def ord
    if self.stoc
      Order.where(project_id: self.id).order("id ASC")
    else
      Order.where(ordered_quantity: 0, project_id: self.id).order("id ASC") 
    end
    # Order.where(if !self.stoc then (ordered_quantity: 0) end, project_id: self.id).order("id ASC")
  end
end
