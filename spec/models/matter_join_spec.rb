require 'rails_helper'

RSpec.describe MatterJoin, type: :model do
  let!(:matter_join) { create(:matter_join) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(matter_join).to be_valid
    end

    # matter
    it 'matterがない場合無効であること' do
      matter_join.matter_id = nil
      matter_join.valid?
      expect(matter_join.errors).to be_added(:matter, :blank)
    end

    # matter or user
    it 'matterとuserがない場合無効であること' do
      matter_join.office_id = nil
      matter_join.user_id = nil
      matter_join.valid?
      expect(matter_join.errors).to be_added(:office_id, :blank)
      expect(matter_join.errors).to be_added(:user_id, :blank)
    end

    # office
    it 'userが無くてもofficeがある場合有効であること' do
      matter_join.office_id = 1
      matter_join.user_id = nil
      expect(matter_join).to be_valid
    end

    # user
    it 'officeが無くてもuserがある場合有効であること' do
      matter_join.office_id = nil
      matter_join.user_id = 1
      expect(matter_join).to be_valid
    end

    # belong_side
    it 'belong_side_idがない場合無効であること' do
      matter_join.belong_side_id = nil
      matter_join.valid?
      expect(matter_join.errors).to be_added(:belong_side_id, :blank)
    end
    xit 'belong_side_idが整数以外だと登録できないこと' do
      matter_join.belong_side_id = 1.5
      matter_join.valid?
      expect(matter_join.errors).to be_added(:belong_side_id, :not_an_integer, value: 1.5)
    end
    xit 'belong_side_idが0だと登録できないこと' do
      matter_join.belong_side_id = 0
      matter_join.valid?
      expect(matter_join.errors).to be_added(:belong_side_id, :greater_than_or_equal_to, count: 1, value: 0)
    end
    xit 'belong_side_idが0未満だと登録できないこと' do
      matter_join.belong_side_id = -1
      matter_join.valid?
      expect(matter_join.errors).to be_added(:belong_side_id, :greater_than_or_equal_to, count: 1, value: -1)
    end
    xit 'belong_side_idが3以上だと登録できないこと' do
      matter_join.belong_side_id = 3
      matter_join.valid?
      expect(matter_join.errors).to be_added(:belong_side_id, :less_than_or_equal_to, count: 2, value: 3)
    end
  end
end
