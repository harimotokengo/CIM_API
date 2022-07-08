FactoryBot.define do
  factory :client_join do
    belong_side_id { '組織' }
    admin { true }
    association :user
    association :client
    association :office
  end
end
