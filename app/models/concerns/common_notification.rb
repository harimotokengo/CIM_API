module CommonNotification
  extend ActiveSupport::Concern

  def create_assign_notification!(current_user, assign_user)
    # 自分で自分をアサインした時はnilを返す
    return nil if current_user.id == assign_user.id

    # 一度担当登録している場合は通知を作成しない
    temp = Notification.where(
      task_id: id,
      sender_id: current_user.id,
      receiver_id: assign_user.id,
      action: "#{self.class.name}_assign"
    )
    return nil if temp.present?

    notification = current_user.active_notifications.new(
      task_id: id,
      receiver_id: assign_user.id,
      action: "#{self.class.name}_assign"
    )
    notification.save if notification.valid?
  end
end