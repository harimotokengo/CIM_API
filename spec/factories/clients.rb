FactoryBot.define do
  factory :client do
    name { 'テスト姓' }
    name_kana { 'てすとせい' }
    first_name { 'テスト名' }
    first_name_kana { 'てすとめい' }
    profile { 'テストプロフィール' }
    indentification_number { '452333443' }
    birth_date { '2000-01-01' }
    client_type_id { '法人' }
    archive { true }
  end
end
