# == Schema Information
#
# Table name: cars
#
#  id              :bigint           not null, primary key
#  itp_expiry_date :date
#  number_plate    :string
#  rca_expiry_date :date
#  rov_expiry_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Car, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
