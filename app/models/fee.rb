class Fee < ApplicationRecord
  # has_many :task_fee_relations, dependent: :destroy
  # has_many :fee_tasks, through: :task_fee_relations, source: :task
  # has_many :work_logs, dependent: :destroy
  # has_many :edit_logs, dependent: :destroy

  belongs_to :matter

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :monthly_date

  with_options presence: true do
    validates :fee_type_id
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :pay_times, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  end

  validates :pay_off, inclusion: { in: [true, false] }
  validates :monthly_date_id,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 31
            },
            allow_blank: true
  validates :current_payment,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_blank: true
  validates :paid_amount,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_blank: true
  validate :check_current_payment

  enum fee_type_id: {
    着手金: 1, 成功報酬: 2, 顧問料: 3,
    相談料: 4, 実費: 5, タイムチャージ: 6,
    その他報酬: 7,
  }

  enum price_type: {
    固定額: 0, 経済的利益: 1
  }
  
  def check_current_payment
    return if current_payment.blank?

    if pay_times.nil?
      errors.add(:pay_times, 'を入力してください。')
    elsif current_payment > pay_times
      errors.add(:current_payment, 'は支払回数以下にしてください。')
    elsif current_payment.negative?
      errors.add(:current_payment, 'は0回数以上にしてください。')
    end
  end

  def fee_type_name
    if fee_type.name == 'タイムチャージ'
      fee_type.name
    else
      fee_type.name + "（#{price.to_s(:delimited)} " +
        if price_type == '固定額'
          '円）'
        else
          '％）'
        end
    end
  end

  # scope作って削除
  def self.active_fees
    where(archive: true)
  end

  # correct_userを作って削除
  def check_fee_destroy_admin(current_user, office, current_belonging_info)
    if matter.present? && inquiry.present?
      @matter_joins = matter.matter_joins.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
      @matter_join = if @matter_joins.exists?(admin: true)
                       @matter_joins.find_by(admin: true)
                     else
                       @matter_joins.first
                     end
      @project_assigns = inquiry.project.project_assigns.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
      @project_assign = if @project_assigns.exists?(admin: true)
                          @project_assigns.find_by(admin: true)
                        else
                          @project_assigns.first
                        end
      if (@matter_joins.present? && @matter_join.admin? && (current_belonging_info.admin? || @matter_join.belong_side_id == 2)) ||
         (@project_assigns.present? && @project_assign.admin? && (current_belonging_info.admin? || @project_assign.belong_side_id == 2))
        true
      else
        false
      end
    elsif matter.present? # matterに紐づいている場合
      @matter_joins = matter.matter_joins.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
      @matter_join = if @matter_joins.exists?(admin: true)
                       @matter_joins.find_by(admin: true)
                     else
                       @matter_joins.first
                     end
      if @matter_joins.present? && @matter_join.admin? && (current_belonging_info.admin? || @matter_join.belong_side_id == 2)
        true
      else
        false
      end
    elsif inquiry.present? # inquiryに紐づいている場合
      @project_assigns = inquiry.project.project_assigns.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
      @project_assign = if @project_assigns.exists?(admin: true)
                          @project_assigns.find_by(admin: true)
                        else
                          @project_assigns.first
                        end
      if @project_assigns.present? && @project_assign.admin? && (current_belonging_info.admin? || @project_assign.belong_side_id == 2)
        true
      else
        false
      end
    else
      false
    end
  end

end
