class Client < ApplicationRecord
  has_many :matters, dependent: :destroy
  has_many :contact_addresses, dependent: :destroy
  has_many :contact_emails, dependent: :destroy
  has_many :contact_phone_numbers, dependent: :destroy
  has_many :client_joins, dependent: :destroy
  has_many :invite_urls, dependent: :destroy
  
  scope :active, -> { where(archive: true) }

  accepts_nested_attributes_for :client_joins, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :matters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :contact_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :contact_emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :contact_phone_numbers, reject_if: :all_blank, allow_destroy: true

  VALID_INDENTIFICATION_NUMBER_REGEX = /\A\d{9}\z/.freeze

  validates :name, presence: true
  validates :name_kana, presence: true
  validates :client_type_id, presence: true
  validates :indentification_number,
            format: { with: VALID_INDENTIFICATION_NUMBER_REGEX,
                      message: 'でない値が入力されています' },
            allow_blank: true

  enum client_type_id: {
    法人: 1, 個人: 2, 相談: 3
  }

  def name=(value)
    value.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') if value.is_a?(String)
    super(value)
  end



  def first_name=(value)
    value.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') if value.is_a?(String)
    super(value)
  end

  def first_name_kana=(value)
    value.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') if value.is_a?(String)
    super(value)
  end

  def maiden_name=(value)
    value.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') if value.is_a?(String)
    super(value)
  end

  def maiden_name_kana=(value)
    value.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') if value.is_a?(String)
    super(value)
  end

  def full_name
    if client_type_id == 1
      name
    else
      name + first_name
    end
  end

  def full_name_kana
    if client_type_id == 1
      name_kana
    else
      name_kana + first_name_kana
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_client_attributes
    %w[name first_name name_kana first_name_kana profile indentification_number
        birth_date client_type_id archive]
  end

  def join_check(current_user)
    return true if personal_join_check(current_user) || office_join_check(current_user)
  end

  def admin_check(current_user)
    user_admin_check = client_joins.where(admin: true, user_id: current_user).exists?
    office_admin_check = client_joins.where(admin: true, 
      office_id: current_user.belonging_office).exists? if current_user.belonging_office
    return true if user_admin_check || office_admin_check
  end

  def destroy_update
    update(
      archive: false
    )
    matters.each do ||matter|
      matter.destroy_update
    end
  end

  def index_data(clients)
    data = []
    clients.each do |client|
      data << client
      matter_data = []
      client.matters.each do |matter|
        matter_data << matter.categories.first.parent
        matter_data << matter.categories.first
        matter_data << matter.tags
      end
      data << matter_data
    end
    return data
  end

  def personal_join_check(current_user)
    client_joins.where(user_id: current_user).exists?
  end

  def office_join_check(current_user)
    client_joins.where(office_id: current_user.belonging_office).exists?  if current_user.belonging_office
  end

  def minimum_required_administrator_check(client_join)
    if client_joins.where(admin: true).count == 1 && client_join.admin?
      errors.add(:base, '管理者は最低1人以上必要です。')
      return false
    else
      return true
    end
  end

  # matter_joinしてるofficeとuserの一覧表示用データ取得
  def index_client_join_data
    data = []
    client_joins = self.client_joins.eager_load(:office)
                      .eager_load(:user)
    client_joins.each do |client_join|
      if client_join.belong_side_id == '組織'
        data << client_join.office
      else
        data << client_join.user
      end
      data << client_join.admin
    end
    return data
  end

  private

  ransacker :client_full_name do
    Arel.sql("CONCAT(clients.name, clients.first_name)")
  end

  ransacker :client_full_name_kana do
    Arel.sql("CONCAT(clients.name_kana, clients.first_name_kana)")
  end
end