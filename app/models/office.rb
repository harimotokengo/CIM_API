class Office < ApplicationRecord
  has_many :belonging_infos, dependent: :destroy
  has_many :users, through: :belonging_infos
  has_many :current_belongings, -> { belonging }, class_name: 'BelongingInfo'
  has_many :belonging_users, through: :current_belongings, source: :user
  has_many :past_belongings, -> { belonged }, class_name: 'BelongingInfo'
  has_many :belonged_users, through: :current_belongings, source: :user

  has_many :tasks, through: :users
  # has_many :matter_joins, dependent: :destroy
  # has_one :subscription, dependent: :destroy
  # has_many :status_groups, dependent: :destroy

  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/.freeze
  VALID_POST_CODE_REGEX = /\A\d{3}-\d{4}$|^\d{3}-\d{2}$|^\d{3}$|^\d{5}$|^\d{7}\z/.freeze
  VALID_KANJI_REGEX = /\A[一-龥]+\z/.freeze
  validates :name, presence: true, length: { maximum: 50 }

  validates :phone_number,
            presence: true,
            format: { with: VALID_PHONE_NUMBER_REGEX,
                      message: 'でない値が入力されています' }

  validates :post_code,
            format: { with: VALID_POST_CODE_REGEX,
                      message: 'でない値が入力されています' },
            allow_blank: true
  validates :prefecture,
            length: { maximum: 4 },
            format: { with: VALID_KANJI_REGEX,
                      message: 'は漢字で入力して下さい' },
            allow_blank: true
  validates :address,
            length: { maximum: 50 },
            allow_blank: true
  
  # 事務所を登録して自身を所属させる
  def save_office(current_user)
    return false if invalid?

    office = self.save
    BelonginInfo.create!(user_id: current_user.id, office_id: office.id, status_id: '所属', admin: true)
  end
end