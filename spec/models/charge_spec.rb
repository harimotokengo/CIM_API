require 'rails_helper'

RSpec.describe 'Charge', type: :model do
  let!(:charge) { create(:charge) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(charge).to be_valid
    end

    # user
    it 'ユーザーがない場合無効であること' do
      charge.user_id = nil
      charge.valid?
      expect(charge.errors).to be_added(:user, :blank)
    end

    # matter
    it '案件がない場合無効であること' do
      charge.matter_id = nil
      charge.valid?
      expect(charge.errors).to be_added(:matter, :blank)
    end
  end
end
