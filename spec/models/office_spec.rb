require 'rails_helper'

RSpec.describe Office, type: :model do
  let!(:office) { create(:office) }

  describe 'validates' do
    context '正常系' do
      it '有効なファクトリを持つこと' do
        expect(office).to be_valid
      end
    end

    context '準正常系' do
      it '事務所名がない場合無効であること' do
        office.name = nil
        office.valid?
        expect(office.errors).to be_added(:name, :blank)
      end
  
      it '電話番号がない場合無効であること' do
        office.phone_number = nil
        office.valid?
        expect(office.errors).to be_added(:phone_number, :blank)
      end
  
      it '事務所名が51文字の場合無効であること' do
        office.name = 'a' * 51
        office.valid?
        expect(office.errors).to be_added(:name, :too_long, count: 50)
      end
  
      it '都道府県が5文字以上の場合無効であること' do
        office.prefecture = '東東東京都'
        office.valid?
        expect(office.errors).to be_added(:prefecture, :too_long, count: 4)
      end
  
      it '住所が51文字以上の場合無効であること' do
        office.address = 'a' * 51
        office.valid?
        expect(office.errors).to be_added(:address, :too_long, count: 50)
      end
  
      it '電話番号のフォーマットが適切でない場合無効であること' do
        office.phone_number = '39012345678'
        office.valid?
        expect(office.errors[:phone_number]).to include 'でない値が入力されています'
      end
  
      it '郵便番号のフォーマットが適切でない場合無効であること' do
        office.post_code = '12-7894'
        office.valid?
        expect(office.errors[:post_code]).to include 'でない値が入力されています'
      end
  
      it '都道府県のフォーマットが適切でない場合無効であること' do
        office.prefecture = 'ぎふ'
        office.valid?
        expect(office.errors[:prefecture]).to include 'は漢字で入力して下さい'
      end
    end
  end
end
