class MatterJoin < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :user, optional: true
  belongs_to :matter

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

  # 組織と個人でmatter_joinの親を分岐してセット
  def set_joiner(current_user)
    if  self.belong_side_id == '組織'
      self.office_id = current_user.belonging_office.id
    else
      self.user_id = current_user.id
    end
  end

  def joining_check(current_user)
    if self.belong_side_id == '組織'
      if !current_user.belonging_check
        errors.add(:base, '無所属ユーザーは組織で参加できません')
        return false
      elsif !self.matter.office_join_check(current_user) && !self.matter.client.office_join_check(current_user)
        return true
      else
        errors.add(:base, '参加済みです')
        return false
      end
    else
      if !self.matter.personal_join_check(current_user) && !self.matter.client.personal_join_check(current_user)
        return true
      else
        errors.add(:base, '参加済みです')
        return false
      end
    end
  end
end
