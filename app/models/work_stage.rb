class WorkStage < ApplicationRecord
  belongs_to :matter_category
  belongs_to :office, optional: true
  belongs_to :user, optional: true

  has_many :task_templates
  has_many :tasks

  scope :active, -> { where(archive: true) }

  validates :name, presence: true,
                   length: { maximum: 100 }

  with_options presence: true do
    validates :office_id, if: :user_id_blank
    validates :user_id, if: :office_id_blank
  end

  def office_id_blank
    office_id.blank?
  end

  def user_id_blank
    user_id.blank?
  end

  # task_templateとtaskのどっちも所持してないwork_stageは
  # 誰でも使用可能
  # デフォで用意するwork_stageはtask_templateとtaskのどっちも所持しない

  # 削除はarchive
end
