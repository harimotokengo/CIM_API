FactoryBot.define do
  factory :matter_join do
    belong_side_id { '組織' }
    admin { true }
    association :user
    association :matter
    association :office
  end
end
