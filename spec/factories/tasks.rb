FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "テストタスク#{n}" }
    deadline { '2030-01-01T17:30:00+09:00' }
    description { 'テストタスク詳細' }
    task_status { '未稼働' }
    priority { '低い' }
    complete { false }
    archive { true }
    association :user
    association :matter
    association :work_stage
  end

  trait :no_working do
    sequence(:name) { |n| "未稼働タスク#{n}" }
    task_status { '未稼働' }
  end
  trait :will_work do
    sequence(:name) { |n| "対応予定タスク#{n}" }
    task_status { '対応予定' }
  end
  trait :working do
    sequence(:name) { |n| "稼働中タスク#{n}" }
    task_status { '稼働中' }
  end
  trait :finish do
    sequence(:name) { |n| "終了タスク#{n}" }
    task_status { '終了' }
  end
end
