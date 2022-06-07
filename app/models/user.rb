class User < ApplicationRecord
  p 33333333333
  authenticates_with_sorcery!
  has_one_attached :avatar

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # 8文字大文字小文字英数混在　記号を含む場合は(?=.*?[\W_])を追加
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[!-~]{8,}+\z/.freeze

  # office,belonging_infoとの同時登録時にuniqueエラー
  validates :email, presence: true,
                    uniqueness: { case_sensitive: true },
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX,
                              message: 'でない値が入力されています' }

  # create
  validates :password, format: { with: VALID_PASSWORD_REGEX }, presence: true, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  # update
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_blank: true, on: :update
  validates :password, confirmation: true, on: :update
  validates :password_confirmation, presence: true, on: :update, if: :password_present

  def password_present
    password.present?
  end
  validates :membership_number,
            numericality: {
              only_integer: true
              # greater_than_or_equal_to: 1,
              # less_than_or_equal_to: 8,
            },
            allow_blank: true
  validates :last_name_kana,
            presence: true,
            length: { maximum: 15 },
            format: { with: /\A[ぁ-んー－]+\z/,
                      message: 'は全角ひらがなで入力して下さい' }
  validates :first_name_kana,
            presence: true,
            length: { maximum: 15 },
            format: { with: /\A[ぁ-んー－]+\z/,
                      message: 'は全角ひらがなで入力して下さい' }

end
