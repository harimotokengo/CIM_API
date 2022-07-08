FactoryBot.define do
  factory :user do
    last_name { 'テスト' }
    first_name { 'ユーザー' }
    last_name_kana { 'てすと' }
    first_name_kana { 'ゆーざー' }
    membership_number { 11_111 }
    user_job_id { 1 }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'Test-1234' }
    password_confirmation { 'Test-1234' }
    archive { true }
  end
end
