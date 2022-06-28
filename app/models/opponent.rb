class Opponent < ApplicationRecord
  belongs_to :matter
  has_many :contact_addresses, dependent: :destroy
  has_many :contact_emails, dependent: :destroy
  has_many :contact_phone_numbers, dependent: :destroy
  # has_many :edit_logs, dependent: :destroy

  accepts_nested_attributes_for :contact_addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :contact_emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :contact_phone_numbers, reject_if: :all_blank, allow_destroy: true

  with_options presence: true do
    validates :name
    validates :name_kana
    validates :opponent_relation_type
  end

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

  enum opponent_relation_type: {
    相手方: 100, 当事者: 200, 配偶者: 300, 代表者: 400, 出資者: 500, 代理人: 600, 関係者: 700, その他: 999
  }

  # フルネームで表示させるためのメソッド
  def full_name
    if first_name.blank?
      name
    else
      name + first_name
    end
  end

  def full_name_kana
    if first_name_kana.blank?
      name_kana
    else
      name_kana + first_name_kana
    end
  end

  def age
    if birth_date.present?
      d1 = birth_date.strftime('%Y%m%d').to_i
      d2 = Date.today.strftime('%Y%m%d').to_i
      (d2 - d1) / 10_000
    end
  end

  # correct_userを作ってこれ消す
  def check_opponent_destroy_admin(current_user, office, current_belonging_info)
    @matter_joins = matter.matter_joins.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
    @matter_join = if @matter_joins.exists?(admin: true)
                     @matter_joins.find_by(admin: true)
                   else
                     @matter_joins.first
                   end
    if @matter_joins.present? && @matter_join.admin? && (current_belonging_info.admin? || @matter_join.belong_side_id == 2)
      true
    else
      false
    end
  end

end