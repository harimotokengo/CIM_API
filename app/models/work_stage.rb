class WorkStage < ApplicationRecord
  belongs_to :matter_category
  belongs_to :user, optional: true

  has_many :task_templates
  has_many :tasks

  scope :active, -> { where(archive: true) }

  validates :name, presence: true,
                   length: { maximum: 100 }

  # task_templateとtaskのどっちも所持してないwork_stageは
  # 誰でも使用可能
  # デフォで用意するwork_stageはtask_templateとtaskのどっちも所持しない

  # 削除はarchive
end
