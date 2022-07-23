class WorkStage < ApplicationRecord
  belongs_to :matter_category
  belongs_to :user, optional: :true

  has_many :task_templates, optional: :true
  has_many :tasks, optional: :true

  validates :name, presence: :true

  # task_templateとtaskのどっちも所持してないwork_stageは
  # 誰でも使用可能
  # デフォで用意するwork_stageはtask_templateとtaskのどっちも所持しない
end
