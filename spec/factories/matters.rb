FactoryBot.define do
  factory :matter do
    matter_status_id { 1 }
    service_price { '12345678' }
    description { 'テストマタープロフィール' }
    association :user
    association :client
    archive { true }
    after(:build) do |matter|
      parent_category = create(:matter_category)
      child_category = parent_category.children.create(name: "離婚")
      matter.matter_category_id = child_category.id
    end
  end
end
