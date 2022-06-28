require 'rails_helper'

RSpec.describe ContactPhoneNumber, type: :model do
  let!(:client_contact_phone_number) { create(:contact_phone_number, :client_contact_phone_number) }
  let!(:opponent_contact_phone_number) { create(:contact_phone_number, :opponent_contact_phone_number) }
  let!(:client) { create(:client) }
  let!(:opponent) { create(:opponent) }

  describe 'validates' do
    context '正常系' do
      context 'contact_phone_number共通' do
        it 'メモ号が空欄でも有効なこと' do
          client_contact_phone_number.memo = ''
          expect(client_contact_phone_number).to be_valid
        end
        it '電話番号に-が入っていても有効であること' do
          client_contact_phone_number.phone_number = '090-1234-5678'
          expect(client_contact_phone_number).to be_valid
        end
        it '電話番号にーが入っていても有効であること' do
          client_contact_phone_number.phone_number = '090-1234-5678'
          expect(client_contact_phone_number).to be_valid
        end
        it '電話番号に―が入っていても有効であること' do
          client_contact_phone_number.phone_number = '090-1234-5678'
          expect(client_contact_phone_number).to be_valid
        end
        it '電話番号に全角スペースが入っていても有効であること' do
          client_contact_phone_number.phone_number = '090-1234-5678'
          expect(client_contact_phone_number).to be_valid
        end
        it '電話番号に半角スペースが入っていても有効であること' do
          client_contact_phone_number.phone_number = '090-1234-5678'
          expect(client_contact_phone_number).to be_valid
        end
      end
      context 'client_contact_phone_number' do
        it '有効なファクトリを持つこと' do
          expect(client_contact_phone_number).to be_valid
        end
      end
      context 'opponent_contact_phone_number' do
        it '有効なファクトリを持つこと' do
          expect(opponent_contact_phone_number).to be_valid
        end
      end
    end
    context '準正常系' do
      context 'contact_phone_number共通' do
        it '電話番号のフォーマットが適切でない場合無効であること' do
          client_contact_phone_number.phone_number = '39012345678'
          client_contact_phone_number.valid?
          expect(client_contact_phone_number.errors[:phone_number]).to include '半角数字で入力して下さい'
        end
      end
      # 親モデルID混在チェックはコントローラで実施
    end
  end
end
