require 'rails_helper'

RSpec.describe 'InviteUrl', type: :model do
  let!(:invite_url) { create(:invite_url) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(invite_url).to be_valid
    end

    # user
    it 'userがない場合無効であること' do
      invite_url.user_id = nil
      invite_url.valid?
      expect(invite_url.errors).to be_added(:user, :blank)
    end

    # matter or client
    it 'matterとclientがない場合無効であること' do
      invite_url.matter_id = nil
      invite_url.client_id = nil
      invite_url.valid?
      expect(invite_url.errors).to be_added(:matter_id, :blank)
      expect(invite_url.errors).to be_added(:client_id, :blank)
    end

    # matter
    it 'clientが無くてもmatterがある場合有効であること' do
      invite_url.matter_id = 1
      invite_url.client_id = nil
      expect(invite_url).to be_valid
    end

    # client
    it 'matterが無くてもclientがある場合有効であること' do
      invite_url.matter_id = nil
      invite_url.client_id = 1
      expect(invite_url).to be_valid
    end

    # token
    it 'tokenがない場合無効であること' do
      invite_url.token = nil
      invite_url.valid?
      expect(invite_url.errors).to be_added(:token, :blank)
    end

    # finish_date
    it 'finish_dateがない場合無効であること' do
      invite_url.limit_date = nil
      invite_url.valid?
      expect(invite_url.errors).to be_added(:limit_date, :blank)
    end
  end
end
