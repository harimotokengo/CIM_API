require 'rails_helper'

RSpec.describe FolderUrl, type: :model do
  let!(:folder_url) { create(:folder_url) }
  let!(:matter) { create(:matter) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(folder_url).to be_valid
    end

    # matter
    it 'matterがない場合無効であること' do
      folder_url.matter = nil
      folder_url.valid?
      expect(folder_url.errors).to be_added(:matter, :blank)
    end

    # name
    it 'nameがない場合無効であること' do
      folder_url.name = nil
      folder_url.valid?
      expect(folder_url.errors).to be_added(:name, :blank)
    end

    # url
    it 'urlがない場合無効であること' do
      folder_url.url = nil
      folder_url.valid?
      expect(folder_url.errors).to be_added(:url, :blank)
    end
  end
end
