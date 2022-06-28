class ContactAddress < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :opponent, optional: true
  # has_many :edit_logs, dependent: :destroy

  VALID_POST_CODE_REGEX = /\A\d{3}-\d{4}$|^\d{3}-\d{2}$|^\d{3}$|^\d{5}$|^\d{7}\z/.freeze
  VALID_KANJI_REGEX = /\A[一-龥]+\z/.freeze

  validates :post_code,
            format: { with: VALID_POST_CODE_REGEX,
                      message: 'でない値が入っています。' },
            allow_blank: true
  validates :prefecture,
            length: { maximum: 4 },
            format: { with: VALID_KANJI_REGEX,
                      message: 'は漢字で入力して下さい' },
            allow_blank: true
  validates :address,
            length: { maximum: 50 },
            allow_blank: true
  validate :pearent_present
  validate :input_confirmation

  enum category: {
    現住所: 100, 職場: 200, 実家: 300, 友人宅: 400, その他: 999
  }

  def parent_present
    if client.blank? ^ opponent.blank?
      if client.blank?
        errors.add(:base, 'クライアントに紐づかない電話番号は登録できません。')
      elsif opponent.blank?
        errors.add(:base, '関係者に紐づかない電話番号は登録できません。')
      end
    end
  end

  def input_confirmation
    if post_code.blank? && prefecture.blank? && address.blank?
      errors.add(:base, 'いずれかの入力が無い場合は登録できません。')
    end
  end

end
