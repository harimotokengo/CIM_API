FactoryBot.define do
  factory :matter_join do
    belong_side_id { 1 }
    admin { true }
    association :user
    association :matter
    association :office
  end
end
