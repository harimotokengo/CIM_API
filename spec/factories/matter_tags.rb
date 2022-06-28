FactoryBot.define do
  factory :matter_tag do
    association :tag
    association :matter
  end
end
