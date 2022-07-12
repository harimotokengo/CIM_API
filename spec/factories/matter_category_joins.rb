FactoryBot.define do
  factory :matter_category_join do
    association :matter
    association :matter_category
  end
end
