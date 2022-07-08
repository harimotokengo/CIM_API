class InviteUserForm
  include ActiveModel::Model
  attr_accessor :email, :password, :password_confirmation,
                :last_name, :first_name, :last_name_kana, :first_name_kana,
                :user_id, :office_id, :status_id, :user_job_id, :membership_number

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX,
                              message: 'でない値が入力されています' }
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :last_name, presence: true, length: { maximum: 15 }
  validates :first_name, presence: true, length: { maximum: 15 }
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

  validates :status_id, presence: true
  validate :email_unique?, if: -> { email.present? }

  def save
    return false if invalid?

    user = User.create(email: email, password: password, password_confirmation: password_confirmation,
                       last_name: last_name, first_name: first_name, last_name_kana: last_name_kana, first_name_kana: first_name_kana,
                       user_job_id: user_job_id)
    BelongingInfo.create(user_id: user.id, office_id: office_id, status_id: status_id)
  end

  private

  def email_unique?
    return true unless User.exists?(email: email)
    errors.add(:email, :taken)
  end
end
