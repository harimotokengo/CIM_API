FactoryBot.define do
  factory :client_join do
    belong_side_id { 1 }
    admin { true }
    association :user
    association :client
    association :office
  end
end
