FactoryBot.define do
  factory :task_template_group do
    association :user
    office_id { nil }
    association :matter_category
    sequence(:name) { |n| "テストタスクグループ#{n}" }
    description { 'タスクグループ詳細' }
    public_flg { true }
  end
end
