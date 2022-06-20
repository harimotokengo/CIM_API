FactoryBot.define do
  factory :user_invite do
    association :sender, factory: :user
    token { '0123456789abcdef' }
    limit_date { Time.now.tomorrow }
    join { false } 
  end
end
