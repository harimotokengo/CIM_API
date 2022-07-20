require 'rails_helper'

RSpec.describe 'MatterAssign', type: :model do
  let!(:matter_assign) { create(:matter_assign) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(matter_assign).to be_valid
    end

    # user
    it 'ユーザーがない場合無効であること' do
      matter_assign.user_id = nil
      matter_assign.valid?
      expect(matter_assign.errors).to be_added(:user, :blank)
    end

    # matter
    it '案件がない場合無効であること' do
      matter_assign.matter_id = nil
      matter_assign.valid?
      expect(matter_assign.errors).to be_added(:matter, :blank)
    end
  end
end