FactoryBot.define do
  factory :user do
    username {SecureRandom.hex(4)}
    email {"#{SecureRandom.hex(4)}@example.org"}
    password {SecureRandom.hex(6)}
    role {SecureRandom.random_number(4)}
    active {true}
  end
end