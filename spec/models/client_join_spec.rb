require 'rails_helper'

RSpec.describe ClientJoin, type: :model do
  let!(:client_join) { create(:client_join) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(client_join).to be_valid
    end

    # matter
    it 'clientがない場合無効であること' do
      client_join.client_id = nil
      client_join.valid?
      expect(client_join.errors).to be_added(:client, :blank)
    end

    # matter or user
    it 'matterとuserがない場合無効であること' do
      client_join.office_id = nil
      client_join.user_id = nil
      client_join.valid?
      expect(client_join.errors).to be_added(:office_id, :blank)
      expect(client_join.errors).to be_added(:user_id, :blank)
    end

    # office
    it 'userが無くてもofficeがある場合有効であること' do
      client_join.office_id = 1
      client_join.user_id = nil
      expect(client_join).to be_valid
    end

    # user
    it 'officeが無くてもuserがある場合有効であること' do
      client_join.office_id = nil
      client_join.user_id = 1
      expect(client_join).to be_valid
    end

    # belong_side
    it 'belong_side_idがない場合無効であること' do
      client_join.belong_side_id = nil
      client_join.valid?
      expect(client_join.errors).to be_added(:belong_side_id, :blank)
    end
    xit 'belong_side_idが整数以外だと登録できないこと' do
      client_join.belong_side_id = 1.5
      client_join.valid?
      expect(client_join.errors).to be_added(:belong_side_id, :not_an_integer, value: 1.5)
    end
    xit 'belong_side_idが0だと登録できないこと' do
      client_join.belong_side_id = 0
      client_join.valid?
      expect(client_join.errors).to be_added(:belong_side_id, :greater_than_or_equal_to, count: 1, value: 0)
    end
    xit 'belong_side_idが0未満だと登録できないこと' do
      client_join.belong_side_id = -1
      client_join.valid?
      expect(client_join.errors).to be_added(:belong_side_id, :greater_than_or_equal_to, count: 1, value: -1)
    end
    xit 'belong_side_idが3以上だと登録できないこと' do
      client_join.belong_side_id = 3
      client_join.valid?
      expect(client_join.errors).to be_added(:belong_side_id, :less_than_or_equal_to, count: 2, value: 3)
    end
  end
end
