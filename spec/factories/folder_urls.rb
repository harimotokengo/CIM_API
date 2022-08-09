FactoryBot.define do
  factory :folder_url do
    name { 'テストURL名' }
    url { 'テストURL' }
    association :matter
  end
end
