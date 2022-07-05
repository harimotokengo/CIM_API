FactoryBot.define do
  factory :contact_email do
    category { '私用' }
    sequence(:email) { |_n| 'contact-email@example.com' }
  end

  trait :client_contact_email do
    association :client
  end

  trait :opponent_contact_email do
    association :opponent
  end
end
