class WorkLog < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :matter, optional: true
  # has_many :edit_logs, dependent: :destroy



  with_options presence: true do
    validates :worked_date
    validates :content
    validates :user_id
    validates :task_id, if: :matter_id_blank
    validates :matter_id, if: :task_id_blank
  end
  validates :detail_reflection, inclusion: { in: [true, false] }
  validates :working_time,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_blank: true

  def matter_id_blank
    self.matter_id.blank?
  end

  def task_id_blank
    self.task_id.blank?
  end

  def set_parent(matter_id, task_id)
    if task_id
      self.task = Task.find(task_id)
    elsif matter_id
      self.matter = Matter.find(matter_id)
    end
  end

  def set_matter
    if self.matter
      @matter = self.matter
    elsif self.task.matter
      @matter = self.task.matter
    end
  end
end
