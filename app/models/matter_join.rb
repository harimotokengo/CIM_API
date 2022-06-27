class MatterJoin < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :user, optional: true
  belongs_to :matter

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :belong_side

  with_options presence: true do
    validates :office_id, if: :user_id_blank
    validates :user_id, if: :office_id_blank
    validates :belong_side_id,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 2
              }
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
