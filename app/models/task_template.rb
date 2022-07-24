class TaskTemplate < ApplicationRecord
  belongs_to :work_stage
  belongs_to :task_template_group

  validates :name, presence: true
end
