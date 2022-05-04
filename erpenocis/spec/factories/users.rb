FactoryBot.define do
  factory :user do
    username {SecureRandom.hex(4)}
    email {"#{SecureRandom.hex(4)}@example.org"}
    password {SecureRandom.hex(6)}
  end
end