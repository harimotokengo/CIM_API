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
end
