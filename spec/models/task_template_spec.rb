require 'rails_helper'

RSpec.describe TaskTemplate, type: :model do
  let!(:task_template) { create(:task_template) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(task_template).to be_valid
    end
    it 'nameがないの場合は登録できないこと' do
      task_template.name = nil
      task_template.valid?
      expect(task_template.errors).to be_added(:name, :blank)
    end
    it 'nameが100文字の場合は登録できること' do
      task_template.name = 'a' * 100
      expect(task_template).to be_valid
    end
    it 'nameが101文字以上の場合は登録できないこと' do
      task_template.name = 'a' * 101
      task_template.valid?
      expect(task_template.errors).to be_added(:name, :too_long, count: 100)
    end
    it 'work_stageがない場合登録出来ないこと' do
      task_template.work_stage_id = nil
      task_template.valid?
      expect(task_template.errors).to be_added(:work_stage, :blank)
    end
    it 'task_template_groupがない場合登録出来ないこと' do
      task_template.task_template_group_id = nil
      task_template.valid?
      expect(task_template.errors).to be_added(:task_template_group, :blank)
    end
  end
end
