FactoryBot.define do
  factory :contact_phone_number do
    category { '私用' }
    phone_number { '09012345678' }
  end

  trait :client_contact_phone_number do
    association :client
  end

  trait :opponent_contact_phone_number do
    association :opponent
  end
end
