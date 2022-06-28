require 'rails_helper'

RSpec.describe Opponent, type: :model do
  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client) }
  let!(:opponent) { create(:opponent, matter: matter) }
  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(opponent).to be_valid
    end

    # matter
    it 'matterがない場合無効であること' do
      opponent.matter_id = nil
      opponent.valid?
      expect(opponent.errors).to be_added(:matter, :blank)
    end

    # name
    it '姓がない場合無効であること' do
      opponent.name = nil
      opponent.valid?
      expect(opponent.errors).to be_added(:name, :blank)
    end

    # name_kana
    it '「かな」がない場合無効であること' do
      opponent.name_kana = nil
      opponent.valid?
      expect(opponent.errors).to be_added(:name_kana, :blank)
    end
      # ひらがな

    # first_name

    # first_name_kana
      # ひらがな

    # 旧性

    # 旧性

    # opponent_relation_type_id
    it 'クライアントタイプがない場合無効であること' do
      opponent.opponent_relation_type = nil
      opponent.valid?
      expect(opponent.errors).to be_added(:opponent_relation_type, :blank)
    end
  end
end
