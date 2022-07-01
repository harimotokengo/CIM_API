class Matter < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :client
  belongs_to :matter_category
  has_many :opponents, dependent: :destroy
  has_many :occurrences, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :fees, dependent: :destroy
  # has_many :charges, dependent: :destroy
  # has_many :matter_assigns, dependent: :destroy
  # has_many :work_logs, dependent: :destroy
  has_many :work_details, dependent: :destroy
  has_many :folder_urls, dependent: :destroy
  has_many :matter_tags, dependent: :destroy
  has_many :tags, through: :matter_tags
  # has_many :invite_urls, dependent: :destroy
  has_many :matter_joins, dependent: :destroy
  
  # has_many :assigned_users, through: :matter_assigns, source: :user
  # has_many :notifications, dependent: :destroy
  # has_many :edit_logs, dependent: :destroy

  accepts_nested_attributes_for :opponents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :fees, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :folder_urls, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :matter_joins, reject_if: :all_blank, allow_destroy: true

  with_options presence: true do
    validates :user_id,:matter_status_id
  end

  enum matter_status_id: {
    受任: 1, 先方検討中: 2, 当方準備中: 3,
    相談のみ: 4, 終了: 5
  }

  validates_inclusion_of :matter_status_id, in: ->(inst) { inst.class.matter_status_ids.keys }

  # enumのバリデーション用にArgumentErrorをオーバーライド
  def matter_status_id=(value)
    self[:matter_status_id] = value
  rescue ArgumentError
    self[:matter_status_id] = nil
  end

  # scope作って消す
  def self.active_matters
    where(archive: true)
  end

  # feeモデルにscopeを作って消す
  def fix_fees
    fees.where.not(fee_type_id: 6)
  end

  def sum_tc_work_logs(now_month, office_id)
    # 先月のログ抽出
    tc_fees = fees.where(fee_type_id: 6)
    tc_fees_work_logs = work_logs.where(worked_date: now_month.prev_month.all_month).joins(:fee).where('fees.id', tc_fees)
    tc_tasks = tasks.joins(:fees).where('fees.fee_type_id = ?', 6)
    tc_tasks_work_logs = work_logs.where(worked_date: now_month.prev_month.all_month).joins(:task).where('tasks.id', tc_tasks)
    tc_work_logs = work_logs.where(id: (tc_fees_work_logs + tc_tasks_work_logs))

    # ログ計算
    # users_sanitize_sql = sanitize_sql('belonging_infos.status_id = ? AND belonging_infos.default_price IS NOT NULL', 1)
    users = Office.find(office_id).belonging_users
    sum_price = 0
    users.each do |user|
      working_time = tc_work_logs.where(user_id: user.id).sum(:working_time)
      hour = (working_time / 60) + (working_time % 60 * 0.0167).round(1)
      sum_price += (user.belonging_infos.find_by(status_id: 1).default_price * hour).round(0)
    end
    return sum_price
  end

  # correct_userを作って消す
  def check_matter_admin(current_user, office, current_belonging_info)
    @matter_joins = matter_joins.where(['office_id = ? OR user_id = ?', office.id, current_user.id])
    @matter_join = if @matter_joins.exists?(admin: true)
                     @matter_joins.find_by(admin: true)
                   else
                     @matter_joins.first
                   end

    # 案件参加 and 案件管理者 and (事務所管理者 or 個人参加)
    if @matter_joins.present? && @matter_join.admin? && (current_belonging_info.admin? || @matter_join.belong_side_id == 2)
      true
    else
      false
    end
  end
end
