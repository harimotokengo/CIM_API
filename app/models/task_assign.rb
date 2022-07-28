class TaskAssign < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validate :joining_user?
  validate :already_assigning?

  def joining_user?
    return false unless self.user_id && self.task_id
    @user = User.active.find(self.user_id)
    if self.task.matter_id
      @matter = Matter.find(self.task.matter_id)
      unless @matter.join_check(@user) || @matter.client.join_check(@user)
        errors.add(:user, '案件参加のない他事務所ユーザーは登録出来ません')
      end
    else
      unless @user.belonging_office && @user.belonging_office == task.user.belonging_office
        errors.add(:user, '他事務所ユーザーは登録出来ません')
      end
    end
  end

  def already_assigning?
    return false unless self.user_id && self.task_id
    if TaskAssign.where(task_id: self.task_id, user_id: self.user_id).exists?
      errors.add(:user, '担当登録済みです')
    end
  end
end
