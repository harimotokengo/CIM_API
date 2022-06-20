FactoryBot.define do
  factory :office do
    name { 'テスト事務所' }
    phone_number { '09012345678' }
    post_code { '110-0001' }
    prefecture { '東京都' }
    address { '' }
    archive { true }
  end
end
