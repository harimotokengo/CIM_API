require 'rails_helper'

RSpec.describe 'Task', type: :model do
  let!(:user) { create(:user) }
  let!(:belonging_info) { create(:belonging_info, status_id: 1, user: user) }
  let!(:other_user) { create(:user) }
  let!(:other_belonging_info) { create(:belonging_info, status_id: 1, user: other_user) }

  let!(:task) { create(:task, user: user, matter_id: '') }
  # let!(:task_assign) { create(:task_assign, user: user, task: task) }
  # let!(:task_assign_notification) { create(:notification, task_id: task.id, sender_id: user.id, receiver_id: user.id, action: 'task_assign') }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(task).to be_valid
    end
    it 'nameがない場合は登録できないこと' do
      task.name = nil
      task.valid?
      expect(task.errors).to be_added(:name, :blank)
    end
    it 'nameが100文字の場合は登録できること' do
      task.name = 'a' * 100
      expect(task).to be_valid
    end
    it 'nameが101文字以上の場合は登録できないこと' do
      task.name = 'a' * 101
      task.valid?
      expect(task.errors).to be_added(:name, :too_long, count: 100)
    end
    it 'descriptionが5000文字の場合は登録できること' do
      task.description = 'a' * 5000
      expect(task).to be_valid
    end
    it 'descriptionが5001文字以上の場合は登録できないこと' do
      task.description = 'a' * 5001
      task.valid?
      expect(task.errors).to be_added(:description, :too_long, count: 5000)
    end
    it 'user_idがない場合は登録できないこと' do
      task.user_id = nil
      task.valid?
      expect(task.errors).to be_added(:user_id, :blank)
    end
  end
end