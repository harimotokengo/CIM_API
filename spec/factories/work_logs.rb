FactoryBot.define do
  factory :work_log do
    working_time { 100 }
    worked_date { '2020-12-12' }
    detail_reflection { true }
    content { 'テストコメント' }
    association :user
    # association :matter
    # association :task
  end
end
