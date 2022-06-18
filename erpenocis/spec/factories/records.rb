# == Schema Information
#
# Table name: records
#
#  id            :bigint           not null, primary key
#  initial_data  :string
#  location      :string
#  modified_data :string
#  record_type   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  model_id      :integer
#  user_id       :bigint           not null
#
# Indexes
#
#  index_records_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :record do
    record_type { "MyString" }
    location { "MyString" }
    initial_data { "MyString" }
    modified_data { "MyString" }
    user { nil }
  end
end
