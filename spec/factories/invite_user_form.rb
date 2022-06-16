FactoryBot.define do
  factory :invite_user_form do
    # user
    last_name { 'テスト' }
    first_name { 'ユーザー' }
    last_name_kana { 'てすと' }
    first_name_kana { 'ゆーざー' }
    membership_number { 11_111 }
    user_job_id { 1 }
    sequence(:email) { |n| "invite_user_form#{n}@example.com" }
    password { 'Test-1234' }
    password_confirmation { 'Test-1234' }
    # belonging_info
    status_id { '所属' }
    # default_price { 20_000 }
  end
end
