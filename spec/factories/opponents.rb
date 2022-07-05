FactoryBot.define do
  factory :opponent do
    name { 'テスト姓' }
    name_kana { 'てすとせい' }
    first_name { 'テスト名' }
    first_name_kana { 'てすとめい' }
    profile { 'テストプロフィール' }
    birth_date { '2000-01-01' }
    opponent_relation_type { '相手方' }
    association :matter
  end
end
