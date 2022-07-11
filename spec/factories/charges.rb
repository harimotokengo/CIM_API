FactoryBot.define do
  factory :charge do
    association :user
    association :matter
  end
end
