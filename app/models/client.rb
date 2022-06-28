class Client < ApplicationRecord
  has_many :matters, dependent: :destroy
  has_many :contact_addresses, dependent: :destroy
  has_many :contact_emails, dependent: :destroy
  has_many :contact_phone_numbers, dependent: :destroy
  has_many :matter_joins, dependent: :destroy

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

end