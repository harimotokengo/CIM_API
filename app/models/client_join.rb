class ClientJoin < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :user, optional: true
  belongs_to :client

  scope :office_join, -> { where(belong_side_id: 1) }
  scope :user_join, -> { where(belong_side_id: 2) }
  
  with_options presence: true do
    validates :office_id, if: :user_id_blank
    validates :user_id, if: :office_id_blank
    validates :belong_side_id
  end

  enum belong_side_id: {
    組織: 1, 個人: 2
  }

  def office_id_blank
    office_id.blank?
  end

  def user_id_blank
    user_id.blank?
  end
end
