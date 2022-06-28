FactoryBot.define do
  factory :contact_address do
    category { '現住所' }
    post_code { '1100001' }
    prefecture { '東京都' }
    address { '渋谷区' }
    send_by_personal { false }
  end

  trait :client_contact_address do
    association :client
  end

  trait :opponent_contact_address do
    association :opponent
  end
end
