require 'rails_helper'

RSpec.describe Client, type: :model do
  let!(:client) { create(:client) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(client).to be_valid
    end

    # name
    it 'クライアント名がない場合無効であること' do
      client.name = nil
      client.valid?
      expect(client.errors).to be_added(:name, :blank)
    end

    # name_kana
    it '「かな」がない場合無効であること' do
      client.name_kana = nil
      client.valid?
      expect(client.errors).to be_added(:name_kana, :blank)
    end

    # first_name
    it '法人クライアントで名がない場合有効であること' do
      client.client_type_id = 1
      client.first_name = nil
      expect(client).to be_valid
    end
    it '個人クライアントで名がない場合有効であること' do
      client.client_type_id = 2
      client.first_name = nil
      expect(client).to be_valid
    end

    # first_name_kana
    it '法人クライアントで名のかながない場合有効であること' do
      client.client_type_id = 1
      client.first_name_kana = nil
      expect(client).to be_valid
    end
    it '個人クライアントで名のかながない場合有効であること' do
      client.client_type_id = 2
      client.first_name_kana = nil
      expect(client).to be_valid
    end

    # indentification_number
    it '識別番号は数字以外無効であること' do
      client.indentification_number = 'ｈｓｒｇｓｄｓｆ'
      client.valid?
      expect(client.errors[:indentification_number]).to include 'でない値が入力されています'
    end
    it '識別番号は8桁以下の場合無効であること' do
      client.indentification_number = '12345678'
      client.valid?
      expect(client.errors[:indentification_number]).to include 'でない値が入力されています'
    end
    it '識別番号は10桁以上の場合無効であること' do
      client.indentification_number = '12345678912'
      client.valid?
      expect(client.errors[:indentification_number]).to include 'でない値が入力されています'
    end
    it '識別番号は空白でも有効であること' do
      client.indentification_number = nil
      expect(client).to be_valid
    end

    # client_type_id
    it 'クライアントタイプがない場合無効であること' do
      client.client_type_id = nil
      client.valid?
      expect(client.errors).to be_added(:client_type_id, :blank)
    end
  end
end
