FactoryBot.define do
  factory :fee do
    fee_type_id { 1 }
    price { 1_000_000 }
    description { 'テストマタープロフィール' }
    deadline { '2020-02-02' }
    pay_times { 1 }
    monthly_date_id { 1 }
    current_payment { 0 }
    price_type { '固定額' }
    paid_date { '2020-02-02' }
    paid_amount { 1_000_000 }
    pay_off { false }
    association :matter
    association :task
  end

  trait :fees do
    fee_type_id { 1 }
    price { 1_000_000 }
    pay_times { 5 }
    deadline { '2020-02-02' }
    current_payment { 0 }
  end
end
