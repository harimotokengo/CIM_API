class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :belonging_info, dependent: :destroy
  has_one :current_belonging, -> { belonging }, class_name: 'BelongingInfo'
  has_one :belonging_office, through: :current_belonging, source: :office
  has_many :sent_user_invites, class_name: 'UserInvite', foreign_key: 'sender_id', dependent: :destroy
  has_many :matters, dependent: :destroy
  has_many :matter_joins, dependent: :destroy
  has_many :client_joins, dependent: :destroy
  has_many :join_matters, through: :matter_joins, source: :matter
  has_many :join_matter_clients, through: :join_matters, source: :client
  has_many :join_clients, through: :client_joins, source: :client #activeがtrueのscope経由にあとで直す
  has_many :join_client_matters, through: :join_clients, source: :matter
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
  validates :last_name, presence: true, length: { maximum: 15 }
  validates :first_name, presence: true, length: { maximum: 15 }
  validates :user_job_id, presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 8
    }
  validates :membership_number,
            numericality: {
              only_integer: true
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

  validate :validate_avatar
  
  # emailを小文字に変換
  before_save { self.email = email.downcase }

  def password_present
    password.present?
  end

  # フルネームで表示させるためのメソッド
  def full_name
    last_name + first_name
  end

  def validate_avatar
    return unless avatar.attached? # ファイルがアタッチされていない場合は何もしない

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'ファイルのサイズは5MBまでにしてください')
    elsif !avatar_is_image?
      errors.add(:avatar, 'ファイルが対応している形式ではありません')
    end
  end

  # 一人事務所ユーザーか管理ユーザーであればtrueを返す
  def admin_check
    if current_belonging.blank? || current_belonging.admin?
      return true
    end
  end

  private

  # アタッチしたファイルが画像かどうかを判別
  def avatar_is_image?
    %w[image/jpg image/jpeg image/gif image/png].include?(avatar.blob.content_type)
  end
end
