class ContactEmail < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :opponent, optional: true
  # has_many :edit_logs, dependent: :destroy

  VALID_EMAIL_REGEX = /\A\S+@\S+\.\S+\z/.freeze

  # emailを小文字に変換
  before_save { self.email = email.downcase }

  validates :email,
            format: { with: VALID_EMAIL_REGEX,
                      message: 'でない値が入力されています' },
            length: { maximum: 255 }
  validate :parent_present

  def parent_present
    if client.blank? ^ opponent.blank?
      if client.blank?
        errors.add(:base, 'クライアントに紐づかない電話番号は登録できません。')
      elsif opponent.blank?
        errors.add(:base, '関係者に紐づかない電話番号は登録できません。')
      end
    end
  end

  enum category: {
    私用: 100, 仕事用: 200, 家族: 300, 友人: 400, その他: 999
  }
end
