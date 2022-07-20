FactoryBot.define do
  factory :matter_assign do
    association :user
    association :matter
  end
end
