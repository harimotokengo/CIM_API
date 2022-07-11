require 'rails_helper'

RSpec.describe Matter, type: :model do
  let!(:matter) { create(:matter) }
  
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(matter).to be_valid
    end

    # client
    it 'クライアントがない場合無効であること' do
      matter.client = nil
      matter.valid?
      expect(matter.errors).to be_added(:client, :blank)
    end

    # matter_status_id
    it 'matter_status_idがない場合無効であること' do
      matter.matter_status_id = nil
      matter.valid?
      expect(matter.errors).to be_added(:matter_status_id, :blank)
    end
    it 'matter_status_idが数字以外だと登録できないこと' do
      matter.matter_status_id = '二'
      matter.valid?
      expect(matter.errors).to be_added(:matter_status_id, :inclusion, value: nil)
    end
    it 'matter_status_idが整数以外だと登録できないこと' do
      matter.matter_status_id = 1.5
      matter.valid?
      expect(matter.errors).to be_added(:matter_status_id, :inclusion, value: nil)
    end
    it 'matter_status_idが0未満だと登録できないこと' do
      matter.matter_status_id = 0
      matter.valid?
      expect(matter.errors).to be_added(:matter_status_id, :inclusion, value: nil)
    end
    it 'matter_status_idが6以上だと登録できないこと' do
      matter.matter_status_id = 6
      matter.valid?
      expect(matter.errors).to be_added(:matter_status_id, :inclusion, value: nil)
    end

    # service_price
    it 'service_priceがない場合でも有効であること' do
      matter.service_price = nil
      expect(matter).to be_valid
    end
    # description
    it 'descriptionがない場合でも有効であること' do
      matter.description = nil
      expect(matter).to be_valid
    end
  end
end
