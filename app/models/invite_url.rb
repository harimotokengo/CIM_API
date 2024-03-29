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

  def get_invite_data
    inviter = self.user.full_name
    limit_date = self.limit_date
    invited_destination_name = self.set_invited_destination_name
    data = {
      inviter: inviter, 
      limit_date: limit_date, 
      invited_destination_name: invited_destination_name}
    return data
  end

  # parent毎にinvited_destination_nameを取得
  def set_invited_destination_name
    if self.matter_id
      return self.matter.client.full_name + ',' + self.matter.categories.first.name
    elsif self.client_id
      return self.client.full_name + ',' + '全案件'
    end
  end

  # 招待URLが正しいかチェック
  def invite_url_check(params_token)
    return true if token_check(params_token) && deadline_check && accessed_check
  end

  def set_token_url
    if Rails.env.development? || Rails.env.test?
      return "http://localhost:3000/invite_urls/#{self.id}?tk=#{self.token}"
    else
      return "https://www.mrcim.com/invite_urls/#{self.id}?tk=#{self.token}"
    end
  end

  private

  def token_check(params_token)
    if self.token == params_token
      return true
    else
      errors.add(:base, '不正なアクセスです')
      return false
    end
  end
end
