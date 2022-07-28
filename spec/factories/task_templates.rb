FactoryBot.define do
  factory :task_template do
    sequence(:name) { |n| "テストタスク#{n}" }
    association :work_stage
    association :task_template_group
  end
end
