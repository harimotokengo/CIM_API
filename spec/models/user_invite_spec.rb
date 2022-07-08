require 'rails_helper'

RSpec.describe UserInvite, type: :model do
  let!(:user_invite) { create(:user_invite) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(user_invite).to be_valid
    end

    it 'senderがない場合無効であること' do
      user_invite.sender_id = nil
      user_invite.valid?
      expect(user_invite.errors).to be_added(:sender, :blank)
    end

    it 'tokenがない場合無効であること' do
      user_invite.token = nil
      user_invite.valid?
      expect(user_invite.errors).to be_added(:token, :blank)
    end

    it 'finish_dateがない場合無効であること' do
      user_invite.limit_date = nil
      user_invite.valid?
      expect(user_invite.errors).to be_added(:limit_date, :blank)
    end
  end
end
