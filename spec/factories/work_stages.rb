FactoryBot.define do
  factory :work_stage do
    sequence(:name) { |n| "テスト作業段階#{n}" }
    archive { true }
    association :user
    association :matter_category
  end
end
