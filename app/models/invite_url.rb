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

  # parent毎にinvited_destination_nameを取得
  def get_invited_destination_name
    if self.matter_id
      @matter = self.matter
      return @matter.client.full_name + ',' + @matter.categories.first
    elsif self.client_id
      @matter = self.client
      return @matter.client.full_name + ',' + '全案件'
    end
  end

  # 招待URLが正しいかチェック
  def invite_check(params_token)
    return true if token_check(params_token) && deadline_check && accessed_check
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
