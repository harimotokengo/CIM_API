class TaskTemplateGroup < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :user, optional: true
  belongs_to :matter_category

  has_many :task_templates, dependent: :destroy

  accepts_nested_attributes_for :task_templates, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true,
                   length: { maximum: 100 }
  validates :description, length: { maximum: 5000 }


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

  # templateを基にmatterのtaskを登録
  def save_matter_tasks(matter, current_user)
    self.task_templates.each do |task_template|
      task = Task.create(
        name: task_template.name,
        user_id: current_user.id,
        matter_id: matter.id,
        work_status_id: task_template.work_status_id
      )
    end
  end

  # ==========
  # テンプレ作成メモ
  # ==========
  # テンプレグループ名入力
  # matter_categoryを選ぶ ancestryはnil
  #   作業段階を選択
  #   作業段階がなければ作成して選択
  #     タスク名を入力
  
end
