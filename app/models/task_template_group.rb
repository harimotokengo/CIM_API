class TaskTemplateGroup < ApplicationRecord
  belongs_to :office, optional: true
  belongs_to :user, optional: true

  with_options presence: true do
    validates :office_id, if: :user_id_blank
    validates :user_id, if: :office_id_blank
    validates :belong_side_id
  end

  enum belong_side_id: {
    組織: 1, 個人: 2
  }

  def office_id_blank
    office_id.blank?
  end

  def user_id_blank
    user_id.blank?
  end

  # templateを基にmatterのtaskを登録
  def save_matter_tasks
    self.task_templates.each do |task_template|
      task = Task.create(
        name: task_template.name,
        user_id: current_user.id,
        matter_id: self.matter.id,
        work_status_id: task_template.work_status_id
      )
      self.tasks << task
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
