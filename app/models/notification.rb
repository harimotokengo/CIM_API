class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :matter, optional: true
  belongs_to :task, optional: true

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  validates :action, presence: true
end
