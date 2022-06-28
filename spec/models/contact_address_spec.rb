require 'rails_helper'

RSpec.describe ContactAddress, type: :model do
  let!(:client_contact_address) { create(:contact_address, :client_contact_address) }
  let!(:invalid_contact_address) { create(:contact_address, :client_contact_address, prefecture: '', address: '') }
  let!(:opponent_contact_address) { create(:contact_address, :opponent_contact_address) }
  let!(:client) { create(:client) }
  let!(:opponent) { create(:opponent) }

  describe 'validates' do
    context '正常系' do
      
      context 'contact_address共通' do
        it '有効なファクトリを持つこと' do
          expect(client_contact_address).to be_valid
        end

        it '有効なファクトリを持つこと' do
          expect(opponent_contact_address).to be_valid
        end

        it 'メモが空欄でも有効なこと' do
          client_contact_address.memo = ''
          expect(client_contact_address).to be_valid
        end
        it '郵便番号が空欄でも有効なこと' do
          client_contact_address.post_code = ''
          expect(client_contact_address).to be_valid
        end
        it '都道府県が空欄でも有効なこと' do
          client_contact_address.prefecture = ''
          expect(client_contact_address).to be_valid
        end
        it '住所が空欄でも有効なこと' do
          client_contact_address.address = ''
          expect(client_contact_address).to be_valid
        end
      end
      
    end
    context '準正常系' do
      context 'contact_address共通' do
        it '都道府県が5文字以上の場合無効であること' do
          client_contact_address.prefecture = '東東東京都'
          client_contact_address.valid?
          expect(client_contact_address.errors).to be_added(:prefecture, :too_long, count: 4)
        end
        it '都道府県がひらがなの場合無効であること' do
          client_contact_address.prefecture = 'ぎふけん'
          client_contact_address.valid?
          expect(client_contact_address.errors).to be_added(:prefecture, :invalid, value: client_contact_address.prefecture)
        end
        it '郵便番号の場合無効であること' do
          client_contact_address.prefecture = 'ぎふけん'
          client_contact_address.valid?
          expect(client_contact_address.errors).to be_added(:prefecture, :invalid, value: client_contact_address.prefecture)
        end
        it '郵便番号のフォーマットが適切でない場合無効であること' do
          client_contact_address.post_code = '12-7894'
          client_contact_address.valid?
          expect(client_contact_address.errors).to be_added(:post_code, :invalid, value: client_contact_address.post_code)
        end
        it '住所が51文字以上の場合無効であること' do
          client_contact_address.address = 'a' * 51
          client_contact_address.valid?
          expect(client_contact_address.errors).to be_added(:address, :too_long, count: 50)
        end
        it '住所、電話番号、メールアドレスのいずれかを入力していない場合、無効であること' do
          invalid_contact_address.post_code = ''
          invalid_contact_address.valid?
          expect(invalid_contact_address.errors[:base]).to include 'いずれかの入力が無い場合は登録できません。'
        end
      end
      # 親モデルID混在チェックはコントローラで実施
    end
  end
end
