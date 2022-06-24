class UserInvite < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  with_options presence: true do
    validates :token
    validates :limit_date
    validates :sender_id
  end
end
