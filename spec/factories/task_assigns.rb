FactoryBot.define do
  factory :task_assign do
    association :user
    association :task
  end
end
