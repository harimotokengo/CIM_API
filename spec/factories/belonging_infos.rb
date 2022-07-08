FactoryBot.define do
  factory :belonging_info do
    association :user
    association :office
    default_price { 20_000 }
    status_id { 1 }
    admin { false }
  end
end
