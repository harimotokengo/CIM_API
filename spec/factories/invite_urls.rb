FactoryBot.define do
  factory :invite_url do
    token { '0123456789abcdef' }
    admin { true }
    limit_date { Time.now.tomorrow }
    join { false }
    association :user
    association :client
    association :matter
  end
end
