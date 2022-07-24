require 'rails_helper'

RSpec.describe WorkStage, type: :model do
  let!(:work_stage) { create(:work_stage) }
  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(work_stage).to be_valid
    end
    it 'nameがないの場合は登録できないこと' do
      work_stage.name = nil
      work_stage.valid?
      expect(work_stage.errors).to be_added(:name, :blank)
    end
    it 'nameが100文字の場合は登録できること' do
      work_stage.name = 'a' * 100
      expect(work_stage).to be_valid
    end
    it 'nameが101文字以上の場合は登録できないこと' do
      work_stage.name = 'a' * 101
      work_stage.valid?
      expect(work_stage.errors).to be_added(:name, :too_long, count: 100)
    end
    it 'user_idがないの場合でも登録できること' do
      work_stage.user_id = nil
      expect(work_stage).to be_valid
    end 
    it 'matter_category_idがないの場合は登録できないこと' do
      work_stage.matter_category_id = nil
      work_stage.valid?
      expect(work_stage.errors).to be_added(:matter_category, :blank)
    end 
  end
end