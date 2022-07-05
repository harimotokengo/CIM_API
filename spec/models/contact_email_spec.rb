require 'rails_helper'

RSpec.describe ContactEmail, type: :model do
  let!(:client_contact_email) { create(:contact_email, :client_contact_email) }
  let!(:opponent_contact_email) { create(:contact_email, :opponent_contact_email) }
  let!(:client) { create(:client) }
  let!(:opponent) { create(:opponent) }

  describe 'validates' do
    context '正常系' do
      context 'contact_email共通' do
        it 'メモが空欄でも有効なこと' do
          client_contact_email.memo = ''
          expect(client_contact_email).to be_valid
        end
      end
      context 'client_contact_email' do
        it '有効なファクトリを持つこと' do
          expect(client_contact_email).to be_valid
        end
      end
      context 'opponent_contact_email' do
        it '有効なファクトリを持つこと' do
          expect(opponent_contact_email).to be_valid
        end
      end
    end
    context '準正常系' do
      context 'contact_email共通' do
        it 'emailが255文字を超えるなら無効であること' do
          client_contact_email.email = "#{'a' * 244}@example.com"
          client_contact_email.valid?
          expect(client_contact_email.errors).to be_added(:email, :too_long, count: 255)
        end
        it 'emailに@が含まれていないなら無効な状態であること' do
          client_contact_email.email = 'samplesample.jp'
          client_contact_email.valid?
          expect(client_contact_email.errors).to be_added(:email, :invalid, value: client_contact_email.email)
        end
      end
      # 親モデルID混在チェックはコントローラで実施
    end
  end
end
