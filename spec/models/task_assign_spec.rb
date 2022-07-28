require 'rails_helper'

RSpec.describe TaskAssign, type: :model do
  let!(:user) { create(:user) }
  let!(:belonging_info) { create(:belonging_info, status_id: 1, user: user) }
  let!(:task) { create(:task, user: user, matter_id: '') }
  let!(:task_assign) { build(:task_assign, user: user, task: task) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(task_assign).to be_valid
    end
    it 'userがない場合は登録できないこと' do
      task_assign.user_id = nil
      task_assign.valid?
      expect(task_assign.errors).to be_added(:user, :blank)
    end
    it 'taskがない場合は登録できないこと' do
      task_assign.task_id = nil
      task_assign.valid?
      expect(task_assign.errors).to be_added(:task, :blank)
    end
  end
end
