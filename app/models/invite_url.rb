class InviteUrl < ApplicationRecord
  belongs_to :user
  belongs_to :matter, optional: true
  belongs_to :client, optional: true

  with_options presence: true do
    validates :matter_id, if: :client_id_blank
    validates :client_id, if: :matter_id_blank
    validates :token
    validates :limit_date
    validates :user_id
  end

  def matter_id_blank
    matter_id.blank?
  end

  def client_id_blank
    client_id.blank?
  end

  # トークンが期限切れしていないか
  def deadline_check
    if self.limit_date > Time.now
      return true
    else
      errors.add(:base, '期限切れのため無効です。')
      return false
    end
  end

  # アクセス済みでないか
  def accessed_check
    if self.join == false
      return true 
    else
      errors.add(:base, 'アクセス済みのため無効です。')
      return false
    end
  end
end
