require 'rails_helper'

RSpec.describe TaskTemplateGroup, type: :model do
  let!(:task_template_group) { create(:task_template_group) }
  let!(:user) { create(:user) }
  let!(:office) { create(:office) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(task_template_group).to be_valid
    end
    it 'matter_categoryがない場合登録出来ないこと' do
      task_template_group.matter_category_id = nil
      task_template_group.valid?
      expect(task_template_group.errors).to be_added(:matter_category, :blank)
    end
    it 'nameがないの場合は登録できないこと' do
      task_template_group.name = nil
      task_template_group.valid?
      expect(task_template_group.errors).to be_added(:name, :blank)
    end

    it 'nameが100文字の場合は登録できること' do
      task_template_group.name = 'a' * 100
      expect(task_template_group).to be_valid
    end

    it 'nameが101文字以上の場合は登録できないこと' do
      task_template_group.name = 'a' * 101
      task_template_group.valid?
      expect(task_template_group.errors).to be_added(:name, :too_long, count: 100)
    end

    it 'user_idもoffice_idも両方存在しない場合登録できないこと' do
      task_template_group.user_id = nil
      task_template_group.office_id = nil
      task_template_group.valid?
      expect(task_template_group.errors).to be_added(:user_id, :blank)
      expect(task_template_group.errors).to be_added(:office_id, :blank)
    end

    it 'user_idとoffice_idが両方存在しても登録できること' do
      task_template_group.user_id = user.id
      task_template_group.office_id = office.id
      expect(task_template_group).to be_valid
    end

    it 'descriptionが5000文字の場合は登録できること' do
      task_template_group.description = 'a' * 5000
      expect(task_template_group).to be_valid
    end
    it 'descriptionが5001文字以上の場合は登録できないこと' do
      task_template_group.description = 'a' * 5001
      task_template_group.valid?
      expect(task_template_group.errors).to be_added(:description, :too_long, count: 5000)
    end
  end
end
