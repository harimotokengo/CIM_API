#===============================================================
# matter_category
#===============================================================
matter_category_parent_array = %i[
  離婚・男女問題 刑事事件 交通事故 労働関連 遺言・遺産相続
  建築・不動産 ネット上のトラブル 債務整理 破産・民事再生
  債権回収 税務・行政事件 医療問題 国際問題 知的財産 企業法務
  顧問 その他案件
]

matter_category_child_array = [
  # 離婚・男女問題
  %i[離婚 財産分与 年金分割  養育費  慰謝料  不倫  その他男女問題 ],
  # 刑事事件 
  %i[],
  # 交通事故 
  %i[],
  # 労働関連 
  %i[],
  # 遺言・遺産相続
  %i[],
  # 建築・不動産 
  %i[],
  # ネット上のトラブル 
  %i[],
  # 債務整理 
  %i[],
  # 破産・民事再生
  %i[],
  # 債権回収 
  %i[ ],
  #税務・行政事件 
  %i[],
  # 医療問題 
  %i[],
  # 国際問題 
  %i[],
  # 知的財産 
  %i[],
  # 企業法務
  %i[],
  # 顧問 
  %i[],
  # その他案件
  %i[],
]

matter_category_parent_array.each_with_index do |parent, i|
  matter_category_parent = MatterCategory.create(name: parent)
  matter_category_child_array[i].each do |child|
    matter_category_parent.children.create(name: child)
  end
end
#===============================================================
# matter_category
#===============================================================

2.times do |n|
  office = Office.create!(
    name: "テスト事務所#{n + 1}",
    phone_number: '0362061106',
    archive: true,
  )
  user = User.create!(
    last_name: "管理者姓#{n + 1}",
    first_name: '管理者名',
    last_name_kana: 'かんりしゃせい',
    first_name_kana: 'かんりしゃめい',
    email: "admin#{n + 1}@example.com",
    password: 'Admin-123',
    password_confirmation: 'Admin-123',
    user_job_id: 1,
    archive: true,
  )
  BelongingInfo.create!(
    user_id: user.id,
    office_id: office.id,
    status_id: 1,
    default_price: 20000,
    admin: true
  )
end

20.times do |n|
  office1_user = User.create!(
    last_name: "1テスト姓#{n}",
    first_name: 'テスト名',
    last_name_kana: 'てすとせい',
    first_name_kana: 'てすとめい',
    email: Faker::Internet.unique.email,
    password: 'Test-123',
    password_confirmation: 'Test-123',
    user_job_id: rand(1..8),
    archive: true
  )
  BelongingInfo.create!(
    user_id: office1_user.id,
    office_id: 1,
    status_id: 1,
    default_price: 20000,
    admin: true
  )
  office2_user = User.create!(
    last_name: "2テスト姓#{n}",
    first_name: 'テスト名',
    last_name_kana: 'てすとせい',
    first_name_kana: 'てすとめい',
    email: Faker::Internet.unique.email,
    password: 'Test-123',
    password_confirmation: 'Test-123',
    user_job_id: rand(1..8),
    archive: true,
  )
  BelongingInfo.create!(
    user_id: office2_user.id,
    office_id: 2,
    status_id: 1,
    default_price: 20000,
    admin: true
  )
end

# Tag.create!(
#   tag_name: "testタグ1"
# )
# Tag.create!(
#   tag_name: "プロジェクト"
# )

# offce_client
50.times do |n|
  Client.create!(
    name: Gimei.name.last.kanji,
    first_name: Gimei.name.first.kanji,
    name_kana: Gimei.name.last.hiragana,
    first_name_kana: Gimei.name.first.hiragana,
    profile: '手続きは絶対秘密にしたいとのこと',
    indentification_number: "#{rand(100000000..999999999)}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
    client_type_id: rand(1..2),
    archive: true,
    contact_phone_numbers_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
      },
    ],
    contact_emails_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        email: Faker::Internet.unique.email,
      },
    ],
    contact_addresses_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        post_code: Faker::Address.zip_code.gsub("-", ""),
        prefecture: Gimei.address.prefecture.kanji,
        address: Gimei.address.city.kanji,
      },
    ],
    client_joins_attributes: [
      {
        office_id: rand(1..Office.count),
        belong_side_id: '組織',
        admin: true
      }
    ],
    
    matters_attributes: [
      {
        user_id: rand(1..2),
        matter_status_id: rand(1..5),
        archive: true,
        opponents_attributes: [
          {
            name: Gimei.name.last.kanji,
            first_name: Gimei.name.first.kanji,
            name_kana: Gimei.name.last.hiragana,
            first_name_kana: Gimei.name.first.hiragana,
            birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
            opponent_relation_type: rand(1..6)*100,
            profile: "テストプロフィール#{n}",
            contact_phone_numbers_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
              },
            ],
            contact_emails_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                email: Faker::Internet.unique.email,
              },
            ],
            contact_addresses_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                post_code: Faker::Address.zip_code.gsub("-", ""),
                prefecture: Gimei.address.prefecture.kanji,
                address: Gimei.address.city.kanji,
              },
            ],
          },
        ],
        matter_joins_attributes: [
          {
            belong_side_id: 1,
            admin: true,
            office_id: rand(1..2),
          },
        ],
        matter_category_joins_attributes: [
          matter_category_id: rand(1..MatterCategory.count)
        ],
      },
    ],
  )
end

# user_client
50.times do |n|
  Client.create!(
    name: Gimei.name.last.kanji,
    first_name: Gimei.name.first.kanji,
    name_kana: Gimei.name.last.hiragana,
    first_name_kana: Gimei.name.first.hiragana,
    profile: '手続きは絶対秘密にしたいとのこと',
    indentification_number: "#{rand(100000000..999999999)}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
    client_type_id: rand(1..2),
    archive: true,
    contact_phone_numbers_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
      },
    ],
    contact_emails_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        email: Faker::Internet.unique.email,
      },
    ],
    contact_addresses_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        post_code: Faker::Address.zip_code.gsub("-", ""),
        prefecture: Gimei.address.prefecture.kanji,
        address: Gimei.address.city.kanji,
      },
    ],
    client_joins_attributes: [
      {
        user_id: rand(1..User.count),
        belong_side_id: '個人',
        admin: true
      }
    ],
    
    matters_attributes: [
      {
        user_id: rand(1..2),
        matter_status_id: rand(1..5),
        archive: true,
        opponents_attributes: [
          {
            name: Gimei.name.last.kanji,
            first_name: Gimei.name.first.kanji,
            name_kana: Gimei.name.last.hiragana,
            first_name_kana: Gimei.name.first.hiragana,
            birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
            opponent_relation_type: rand(1..6)*100,
            profile: "テストプロフィール#{n}",
            contact_phone_numbers_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
              },
            ],
            contact_emails_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                email: Faker::Internet.unique.email,
              },
            ],
            contact_addresses_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                post_code: Faker::Address.zip_code.gsub("-", ""),
                prefecture: Gimei.address.prefecture.kanji,
                address: Gimei.address.city.kanji,
              },
            ],
          },
        ],
        matter_category_joins_attributes: [
          matter_category_id: rand(1..MatterCategory.count)
        ],
      },
    ],
  )
end


matter_status_arr = ['受任', '先方検討中', '当方準備中', '相談のみ', '終了']

# office_matter
50.times do |n|
  client = Client.find(rand(1..Client.count))
  client_join = ClientJoin.where(client_id: client.id).sort_by{rand}.first
  # クライアントに参加しているのが組織が個人かで分岐
  if client_join.belong_side_id == '組織'
    user = client_join.office.belonging_users.sort_by{rand}.first
  else
    user = client_join.user
  end

  # 案件参加の組織と個人で分岐
  belong_side_id = rand(1..2)
  if belong_side_id == 1
    matter_office_id = user.belonging_office.id
    matter_user_id = nil
  else
    mater_office_id = nil
    matter_user_id = user.id
  end

  Matter.create!(
    client_id: client.id,
    user_id: user.id,
    matter_status_id: matter_status_arr[rand(matter_status_arr.size)],
    archive: true,
    opponents_attributes: [
      {
        name: Gimei.name.last.kanji,
        first_name: Gimei.name.first.kanji,
        name_kana: Gimei.name.last.hiragana,
        first_name_kana: Gimei.name.first.hiragana,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
        opponent_relation_type: rand(1..6)*100,
        profile: "テストプロフィール#{n}",
        contact_phone_numbers_attributes: [
          {
            category: "#{rand(1..4)}00".to_i,
            phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
          },
        ],
        contact_emails_attributes: [
          {
            category: "#{rand(1..4)}00".to_i,
            email: Faker::Internet.unique.email,
          },
        ],
        contact_addresses_attributes: [
          {
            category: "#{rand(1..4)}00".to_i,
            post_code: Faker::Address.zip_code.gsub("-", ""),
            prefecture: Gimei.address.prefecture.kanji,
            address: Gimei.address.city.kanji,
          },
        ],
      },
    ],
    matter_joins_attributes: [
      {
        belong_side_id: belong_side_id,
        admin: true,
        office_id: matter_office_id,
        user_id: matter_user_id
      },
    ],
    matter_category_joins_attributes: [
      matter_category_id: MatterCategory.where.not(ancestry: nil).order("RAND()").first.id
    ],
  )
end

20.times do |n|
  Tag.create!(
    tag_name: "テストタグ#{n+1}"
  )
end

Matter.count.times do |n|
  MatterTag.create!(
    matter_id: n+1,
    tag_id: rand(1..Tag.count)
  )
end

# matter_assign
2.times do |n|
  id = n + 1
  matters = Matter.joins(:matter_joins)
                  .joins(client: :client_joins)
                  .where(["matter_joins.office_id = ? or client_joins.office_id = ?", id, id])
  matters.each do |matter|
    2.times do |n|
      if n == 0
        user = User.where(office_id: id).sample
      else
        user = User.where.not(id: user).where(office_id: id).sample
      end
      matter.matter_assigns.create(user: user)
    end
  end
end

# # charge
2.times do |n|
  id = n + 1
  matters = Matter.joins(:matter_joins)
                  .joins(client: :client_joins)
                  .where(["matter_joins.office_id = ? or client_joins.office_id = ?", id, id])
  matters.each do |matter|
    2.times do |n|
      if n == 0
        user = User.where(office_id: id).sample
      else
        user = User.where.not(id: user).where(office_id: id).sample
      end
      matter.charges.create(user: user)
    end
  end
end


# # # task
# # 20.times do |n|
# #   @random_date1 = Random.rand(Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
# #   @random_time1 = Time.at(Random.rand((Time.zone.now + 0.hours).to_i / 30.minute..(Time.zone.now + 22.hours).to_i / 30.minute) * 30.minute)
# #   @random_date2 = Random.rand(Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
# #   @random_time2 = Time.at(Random.rand((Time.zone.now + 0.hours).to_i / 30.minute..(Time.zone.now + 22.hours).to_i / 30.minute) * 30.minute)
# #   @random_date3 = Random.rand(Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
# #   @random_time3 = Time.at(Random.rand((Time.zone.now + 0.hours).to_i / 30.minute..(Time.zone.now + 22.hours).to_i / 30.minute) * 30.minute)
# #   @user = User.find(rand(3..User.count))

# #   Task.create!(
# #     name: "1テストタスク#{n}",
# #     task_status: "#{rand(1..3)}00".to_i,
# #     priority: "#{rand(1..3)}00".to_i,
# #     user_id: 1,
# #     matter: Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", 1]).sample,
# #     start_date: @random_date1,
# #     finish_date: @random_date1,
# #     start_time: @random_time1,
# #     finish_time: @random_time1.since(1.hours),
# #     complete: false,
# #     archive: true,
# #   )
# #   Task.create!(
# #     name: "2テストタスク#{n}",
# #     task_status: "#{rand(1..3)}00".to_i,
# #     priority: "#{rand(1..3)}00".to_i,
# #     user_id: 2,
# #     matter: Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", 2]).sample,
# #     start_date: @random_date2,
# #     finish_date: @random_date2,
# #     start_time: @random_time2,
# #     finish_time: @random_time2.since(1.hours),
# #     complete: false,
# #     archive: true,
# #   )
# #   Task.create!(
# #     name: "3テストタスク#{n}",
# #     task_status: "#{rand(1..3)}00".to_i,
# #     priority: "#{rand(1..3)}00".to_i,
# #     user: @user,
# #     # matter: Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", @user.office_id]).sample,
# #     start_date: @random_date3,
# #     finish_date: @random_date3,
# #     start_time: @random_time3,
# #     finish_time: @random_time3.since(1.hours),
# #     complete: false,
# #     archive: true,
# #   )
# # end

# # # matter_assign
# # 2.times do |n|
# #   id = n + 1
# #   matters = Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", id])
# #   matters.each do |matter|
# #     2.times do |n|
# #       if n == 0
# #         user = User.where(office_id: id).sample
# #       else
# #         user = User.where.not(id: user).where(office_id: id).sample
# #       end
# #       matter.matter_assigns.create(user: user)
# #     end
# #   end
# # end

# # # charge
# # 2.times do |n|
# #   id = n + 1
# #   matters = Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", id])
# #   matters.each do |matter|
# #     2.times do |n|
# #       if n == 0
# #         user = User.where(office_id: id).sample
# #       else
# #         user = User.where.not(id: user).where(office_id: id).sample
# #       end
# #       matter.charges.create(user: user)
# #     end
# #   end
# # end

# # # task_assign
# # 2.times do |n|
# #   id = n + 1
# #   tasks = Task.joins(:user).where(["users.office_id = ?", id])
# #   tasks.each do |task|
# #     2.times do |n|
# #       if n == 0
# #         user = User.where(office_id: id).sample
# #       else
# #         user = User.where.not(id: user).where(office_id: id).sample
# #       end
# #       task.task_assigns.create(user: user)
# #       Notification.create!(
# #         sender_id: rand(1..User.count),
# #         receiver_id: user.id,
# #         task_id: task.id,
# #         action: 'task_assign',
# #         checked: rand(0..1)
# #       )
# #     end
# #   end
# # end


# Tag.create!(
#   tag_name: '誹謗中傷'
# )
# Tag.create!(
#   tag_name: '別居中'
# )
# Tag.create!(
#   tag_name: '債務'
# )
# Tag.create!(
#   tag_name: '集団訴訟'
# )

# 20.times do |n|
#   Tag.create!(
#     tag_name: "テストタグ#{n}"
#   )
# end

# 40.times do |n|
#   MatterTag.create!(
#     matter_id: rand(1..Matter.count),
#     tag_id: rand(1..Tag.count)
#   )
# end


# # 全matterに4件ずつmatter_tagをcreate
# 1.upto(Matter.count) do |n|
#   4.times do |i|
#     MatterTag.create!(
#       matter_id: n,
#       tag_id: i+3,
#     )
#   end
# end

# # # 共有テスト用
# # @matter = Matter.joins(:matter_joins).where(["matter_joins.office_id = ?", 1]).last
# # MatterJoin.create!(
# #   belong_side_id: 2,
# #   admin: true,
# #   user_id: 2,
# #   matter: @matter,
# # )
# # Task.create!(
# #   name: "共有テストタスク",
# #   task_status: "#{rand(1..3)}00".to_i,
# #   priority: "#{rand(1..3)}00".to_i,
# #   user_id: 1,
# #   matter: @matter,
# #   complete: false,
# #   archive: true,
# # )
# # 2.times do |n|
# #   WorkLog.create!(
# #     working_time: 100,
# #     content: "テストログ1user#{n+1}",
# #     worked_date: Time.now,
# #     detail_reflection: true,
# #     user_id: n+1,
# #     matter: @matter,
# #   )
# #   WorkLog.create!(
# #     working_time: 50,
# #     content: "テストログ2user#{n+1}",
# #     worked_date: Time.now,
# #     detail_reflection: true,
# #     user_id: n+1,
# #     matter: @matter,
# #   )
# # end
# # WorkDetail.create!(
# #   title: 'テストタイトル',
# #   start_date: Time.now.beginning_of_month,
# #   finish_date: Time.now.end_of_month,
# #   # item_name: "",
# #   # content: "",
# #   honorific_id: 1,
# #   # discount_price: 10000,
# #   # billing_name: "",
# #   matter: @matter,
# #   user_id: 1,
# # )
# # # 事務所案件
# # 20.times do |n|
# #   MatterJoin.create!(
# #     belong_side_id: 1,
# #     admin: false,

# #     office_id: rand(1..2),
# #     matter_id: rand(1..20)
# #     # 
# #   )
# # end

# # # 個人案件
# # 20.times do |n|
# #   MatterJoin.create!(
# #     belong_side_id: 1,
# #     admin: false,

# #     user_id: rand(1..User.count),
# #     matter_id: rand(21..40)
# #     # 
# #   )
# # end

# # 40.times do |n|
# #   Opponent.create!(
# #     name: Gimei.name.kanji,
# #     name_kana: Gimei.name.hiragana,
# #     birth_date: Faker::Date.between(from: '1980-01-01', to: '2010-01-30'),
# #     profile: 'メモ',
# #     opponent_relation_type: "#{rand(1..6)}00".to_i,
# #     matter_id: rand(1..Matter.count)
# #   )
# # end

# # # fee
# # 40.times do |n|
# #   pay_times_val = rand(1..12)
# #   current_payment_val = rand(1..pay_times_val)
# #   price_val = rand(3..100)
# #   paid_amount_val = rand(1..price_val)
# #   Fee.create!(
# #     fee_type_id: rand(1..4),
# #     price_type: 0,
# #     price: price_val * 10000,
# #     description: '報酬詳細',
# #     deadline: Faker::Date.between(from: '2021-12-01', to: '2022-01-30'),
# #     pay_times: pay_times_val,
# #     monthly_date_id: rand(1..30),
    
# #     current_payment: rand(1..current_payment_val),
# #     paid_date: Faker::Date.between(from: '2021-11-01', to: '2021-11-30'),
# #     paid_amount: paid_amount_val * 10000,
# #     # pay_off: 
# #     matter_id: rand(1..Matter.count),
# #     inquiry_id: rand(1..Inquiry.count)
# #   )
# # end

# 10.times do |n|
#   # client
#   ContactPhoneNumber.create!(
#     client_id: rand(1..Client.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
#   )
#   ContactEmail.create!(
#     client_id: rand(1..Client.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     email: Faker::Internet.unique.email,
#   )
#   ContactAddress.create!(
#     client_id: rand(1..Client.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     post_code: Faker::Address.zip_code.gsub("-", ""),
#     prefecture: Gimei.address.prefecture.kanji,
#     address: Gimei.address.city.kanji
#   )
#   # opponent
#   ContactPhoneNumber.create!(
#     opponent_id: rand(1..Opponent.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
#   )
#   ContactEmail.create!(
#     opponent_id: rand(1..Opponent.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     email: Faker::Internet.unique.email,
#   )
#   ContactAddress.create!(
#     opponent_id: rand(1..Opponent.count),
#     category: "#{rand(1..4)}00".to_i,
#     memo: 'メモ',
#     post_code: Faker::Address.zip_code.gsub("-", ""),
#     prefecture: Gimei.address.prefecture.kanji,
#     address: Gimei.address.city.kanji
#   )
# end

# # 10.times do |n|
# #   FolderUrl.create!(
# #     name: "テストフォルダ#{n}",
# #     url: Faker::Internet.url,
# #     project_id: rand(1..Project.count)
# #   )
# #   FolderUrl.create!(
# #     name: "テストフォルダ#{n+10}",
# #     url: Faker::Internet.url,
# #     inquiry_id: rand(1..Inquiry.count)
# #   )
# #   FolderUrl.create!(
# #     name: "テストフォルダ#{n+20}",
# #     url: Faker::Internet.url,
# #     matter_id: rand(1..Matter.count)
# #   )
# # end

# # 20.times do |n|
# #   InviteUrl.create!(
# #     token: SecureRandom.urlsafe_base64(16),
# #     limit_date: Faker::Date.between(from: '2021-12-01', to: '2021-12-30'),
# #     join: false,
# #     user_id: rand(1..User.count),
# #     project_id: rand(1..Project.count)
# #   )
# #   InviteUrl.create!(
# #     token: SecureRandom.urlsafe_base64(16),
# #     limit_date: Faker::Date.between(from: '2021-12-01', to: '2021-12-30'),
# #     join: false,
# #     user_id: rand(1..User.count),
# #     matter_id: rand(1..Matter.count)
# #   )
# # end

# 20.times do |n|
#   WorkLog.create!(
#     working_time: rand(1..100) * 5,
#     content: "テスト作業#{n}",
#     task_comment: "テストコメント#{n}",
#     worked_date: Faker::Date.between(from: '2021-12-01', to: '2021-12-30'),
#     detail_reflection: true,
#     user_id: rand(1..User.count),
#     matter_id: rand(1..Matter.count)
#   )
#   WorkLog.create!(
#     working_time: rand(1..100) * 15,
#     content: "テスト作業#{n}",
#     task_comment: "テストコメント#{n}",
#     worked_date: Faker::Date.between(from: '2021-12-01', to: '2021-12-30'),
#     detail_reflection: true,
#     user_id: rand(1..User.count),
#     task_id: rand(1..Task.count)
#   )
# end

# 40.times do |n|
#   WorkDetail.create!(
#     title: "テスト明細#{n}",
#     start_date: Faker::Date.between(from: '2021-11-01', to: '2021-11-30'),
#     finish_date: Faker::Date.between(from: '2021-12-01', to: '2021-12-30'),
#     item_name: "テスト品目#{n}",
#     content: '質問回答',
#     discount_price: rand(3..20) * 10000,
#     honorific_id: rand(1..2),
#     user_id: rand(1..User.count),
#     matter_id: rand(1..Matter.count)
#   )
# end

# # 通知
# 25.times do |n|
#   # 案件担当
#   Notification.create!(
#     sender_id: rand(1..User.count),
#     receiver_id: 1,
#     matter_id: rand(1..Matter.count),
#     action: 'matter_assign',
#     checked: rand(0..1)
#   )
#   # タスク終了
#   Notification.create!(
#     sender_id: rand(1..User.count),
#     receiver_id: 1,
#     task_id: rand(1..Task.count),
#     action: 'task_finish',
#     checked: rand(0..1)
#   )
#   # タスク期日1日前
#   Notification.create!(
#     sender_id: 1,
#     receiver_id: 1,
#     task_id: rand(1..Task.count),
#     action: 'task_deadline',
#     checked: rand(0..1)
#   )
# end


# ===========================================
# クライアント検索用
# ===========================================
50.times do |n|
  client_belong_side_id = rand(1..2)
  if client_belong_side_id == 1
    client_user_id = nil
    client_office_id = User.find(1).belonging_office.id
  else
    client_user_id = 1
    client_office_id = nil
  end

  Client.create!(
    name: Gimei.name.last.kanji,
    first_name: Gimei.name.first.kanji,
    name_kana: Gimei.name.last.hiragana,
    first_name_kana: Gimei.name.first.hiragana,
    profile: '手続きは絶対秘密にしたいとのこと',
    indentification_number: "#{rand(100000000..999999999)}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
    client_type_id: rand(1..2),
    archive: true,
    contact_phone_numbers_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
      },
    ],
    contact_emails_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        email: Faker::Internet.unique.email,
      },
    ],
    contact_addresses_attributes: [
      {
        category: "#{rand(1..4)}00".to_i,
        post_code: Faker::Address.zip_code.gsub("-", ""),
        prefecture: Gimei.address.prefecture.kanji,
        address: Gimei.address.city.kanji,
      },
    ],
    client_joins_attributes: [
      {
        user_id: client_user_id,
        office_id: client_office_id,
        belong_side_id: client_belong_side_id,
        admin: true
      }
    ],
    
    matters_attributes: [
      {
        user_id: rand(1..2),
        matter_status_id: rand(1..5),
        archive: true,
        opponents_attributes: [
          {
            name: Gimei.name.last.kanji,
            first_name: Gimei.name.first.kanji,
            name_kana: Gimei.name.last.hiragana,
            first_name_kana: Gimei.name.first.hiragana,
            birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).strftime('%Y-%m-%d'),
            opponent_relation_type: rand(1..6)*100,
            profile: "テストプロフィール#{n}",
            contact_phone_numbers_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                phone_number: Faker::PhoneNumber.cell_phone.gsub("-", ""),
              },
            ],
            contact_emails_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                email: Faker::Internet.unique.email,
              },
            ],
            contact_addresses_attributes: [
              {
                category: "#{rand(1..4)}00".to_i,
                post_code: Faker::Address.zip_code.gsub("-", ""),
                prefecture: Gimei.address.prefecture.kanji,
                address: Gimei.address.city.kanji,
              },
            ],
          },
        ],
        matter_category_joins_attributes: [
          matter_category_id: rand(1..MatterCategory.count)
        ],
      },
    ],
  )
end

# ===========================================
# クライアント検索用
# ===========================================