FactoryBot.define do
  factory :matter do
    matter_status_id { '受任' }
    service_price { '12345678' }
    description { 'テストマタープロフィール' }
    association :user
    association :client
    archive { true }
  end
end
