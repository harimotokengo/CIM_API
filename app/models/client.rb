class Client < ApplicationRecord
  has_many :matters, dependent: :destroy
  has_many :contact_addresses, dependent: :destroy
  has_many :contact_emails, dependent: :destroy
  has_many :contact_phone_numbers, dependent: :destroy
  has_many :client_joins, dependent: :destroy
  has_many :join_users, through: :client_joins #activeがtrueのscope経由にあとで直す

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

  def name_kana=(value)
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
    return true if client_join_check(current_user) || matter_join_check(current_user)
  end

  

  def admin_check(current_user)
    user_admin_check = client_joins.where(admin: true, user_id: current_user).exists?
    office_admin_check = client_joins.where(admin: true, 
      office_id: current_user.belonging_office).exists? if current_user.belonging_office
    return true if user_admin_check || office_admin_check
  end

  def destroy_update
    update(
      # name: '削除済',
      # first_name: '削除済',
      # name_kana: 'さくじょずみ',
      # first_name_kana: 'さくじょずみ',
      # maiden_name: '削除済',
      # maiden_name_kana: 'さくじょずみ',
      # birth_date: nil,
      archive: false
    )
    matters.each do ||matter|
      matter.destroy_update
    end
  end

  private

  def client_join_check(current_user)
    user_join_check = client_joins.where(user_id: current_user).exists?
    office_join_check = client_joins.where(
      office_id: current_user.belonging_office).exists? if current_user.belonging_office
    return true if user_join_check || office_join_check
  end

  def matter_join_check(current_user)
    user_join_check = matters.joins(:matter_joins).where(
      matter_joins: {user_id: current_user}).exists?
    office_join_check = matters.joins(:matter_joins).where(
      matter_joins: {office_id: current_user.belonging_office}).exists? if current_user.belonging_office
    return true if user_join_check || office_join_check
  end

  def self.ransackable_scopes(auth_object = nil)
    %i(full_name_like)
  end
end