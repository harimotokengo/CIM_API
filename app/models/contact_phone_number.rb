class ContactPhoneNumber < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :opponent, optional: true
  # has_many :edit_logs, dependent: :destroy

  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}-?\d{4}|\d{2}-?\d{3}|\d{3}-?\d{2}|\d{4}-?\d{1})-?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/.freeze

  validates :phone_number,
            format: { with: VALID_PHONE_NUMBER_REGEX,
                      message: '半角数字で入力して下さい' }
  validate :parent_present

  def parent_present
    if client.blank? && opponent.blank?
      if client.blank?
        errors.add(:base, 'クライアントに紐づかない電話番号は登録できません。')
      elsif opponent.blank?
        errors.add(:base, '関係者に紐づかない電話番号は登録できません。')
      end
    end
  end

  # 親の排他チェック
end
