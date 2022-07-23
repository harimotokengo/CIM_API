class Task < ApplicationRecord
  belongs_to :matter, optional: true
  belongs_to :user
  belongs_to :task_template_group

  has_many :task_assigns, dependent: :destroy
  has_many :task_assigned_users, through: :task_assigns, source: :user
  has_many :work_logs
  has_many :fees, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :edit_logs, dependent: :destroy

  scope :active, -> { where(archive: true) }

  # accepts_nested_attributes_for :task_assigns, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :fees, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true,
                   length: { maximum: 100 }
  validates :description, length: { maximum: 5000 }
  validates :user_id, presence: true
  validates :work_stage_id, presence: true
  validate :date_before_start
  validate :time_before_start

  enum task_status: {
    未稼働: 1, 対応予定: 2, 稼働中: 3, 終了: 4
  }

  enum priority: {
    低: 1, 中: 2, 高: 3
  }

  def date_before_start
    errors.add(:finish_date, 'は開始日以降を選択してください') if start_date.present? && finish_date.present? && finish_date < start_date
  end

  def time_before_start
    errors.add(:finish_time, 'は開始時間以降を選択してください') if start_date.present? && finish_date.present? && start_time.present? && finish_time.present? && finish_date < start_date && finish_time <= start_time
  end

  def already_task_assigned?(user)
    task_assines.exists?(user_id: user.id)
  end

  # scopeに置き換えが終わったら消す
  def self.active_tasks
    where(archive: true)
  end

  # メソッド名と処理が合致していないので要見直し
  def task_name
    name + "（期限：#{finish_date.strftime('%Y/%m/%d')}）"
  end

  def finish_datetime
    # finish_dateに加算する秒数
    add_time = finish_time.to_i - Time.parse('2000-01-01 00:00:00').to_i
    finish_date.to_time + add_time
  end
end