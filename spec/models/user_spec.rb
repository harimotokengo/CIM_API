require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'validates' do
    context '正常系' do
      before do
        user.avatar = fixture_file_upload('test.jpg')
      end
      it 'userモデル項目全て存在すれば登録できる' do
        expect(user).to be_valid
      end
      it 'last_nameが15文字の場合は登録できること' do
        user.last_name = 'a' * 15
        expect(user).to be_valid
      end
    end

    context '準正常系' do
      it 'last_nameがない場合は登録できないこと' do
        user.last_name = nil
        user.valid?
        expect(user.errors).to be_added(:last_name, :blank)
      end
      it 'last_nameが16文字以上の場合は登録できないこと' do
        user.last_name = 'a' * 16
        user.valid?
        expect(user.errors).to be_added(:last_name, :too_long, count: 15)
      end
  
      it 'first_nameがない場合は登録できないこと' do
        user.first_name = nil
        user.valid?
        expect(user.errors).to be_added(:first_name, :blank)
      end
  
      it 'first_nameが15文字以上の場合は登録できないこと' do
        user.first_name = 'a' * 15
        expect(user).to be_valid
      end
  
      it 'first_nameが16文字以上の場合は登録できないこと' do
        user.first_name = 'a' * 16
        user.valid?
        expect(user.errors).to be_added(:first_name, :too_long, count: 15)
      end
  
      it 'emailがない場合は登録できないこと' do
        user.email = nil
        user.valid?
        expect(user.errors).to be_added(:email, :blank)
      end
  
      it 'emailがユニークでない場合は登録できないこと' do
        user.email = other_user.email
        user.valid?
        expect(user.errors).to be_added(:email, :taken, value: user.email)
      end
  
      it 'emailが255文字以下なら有効であること' do
        user.email = "#{'a' * 243}@example.com"
        expect(user).to be_valid
      end
  
      it 'emailが255文字を超えるなら無効であること' do
        user.email = "#{'a' * 244}@example.com"
        user.valid?
        expect(user.errors).to be_added(:email, :too_long, count: 255)
      end
  
      it 'emailに@が含まれていないなら無効な状態であること' do
        user.email = 'samplesample.jp'
        user.valid?
        expect(user.errors).to be_added(:email, :invalid, value: user.email)
      end
  
      it 'emailは全て小文字で保存される' do
        user.email = 'SAMPLE@SAMPLE.JP'
        user.save
        expect(user.reload.email).to eq 'sample@sample.jp'
      end
  
      it 'last_name_kanaが無いと登録できないこと' do
        user.last_name_kana = nil
        user.valid?
        expect(user.errors).to be_added(:last_name_kana, :blank)
      end
  
      it 'last_name_kanaが15文字以内なら登録できること' do
        user.last_name_kana = 'あ' * 15
        expect(user).to be_valid
      end
  
      it 'last_name_kanaが16文字以上なら登録できないこと' do
        user.last_name_kana = 'あ' * 16
        user.valid?
        expect(user.errors).to be_added(:last_name_kana, :too_long, count: 15)
      end
  
      it 'last_name_kanaが全角ひらがな以外は登録できないこと' do
        user.last_name_kana = 'テスト'
        user.valid?
        expect(user.errors[:last_name_kana]).to include 'は全角ひらがなで入力して下さい'
      end
  
      it 'first_name_kanaが無いと登録できないこと' do
        user.first_name_kana = nil
        user.valid?
        expect(user.errors).to be_added(:first_name_kana, :blank)
      end
  
      it 'first_name_kanaが15文字以内なら登録できること' do
        user.first_name_kana = 'あ' * 15
        expect(user).to be_valid
      end
  
      it 'first_name_kanaが16文字以上なら登録できないこと' do
        user.first_name_kana = 'あ' * 16
        user.valid?
        expect(user.errors).to be_added(:first_name_kana, :too_long, count: 15)
      end
  
      it 'first_name_kanaが全角ひらがな以外は登録できないこと' do
        user.first_name_kana = 'テスト'
        user.valid?
        expect(user.errors[:first_name_kana]).to include 'は全角ひらがなで入力して下さい'
      end
  
      it 'user_job_idが無いと登録できないこと' do
        user.user_job_id = nil
        user.valid?
        expect(user.errors).to be_added(:user_job_id, :blank)
      end
  
      it 'user_job_idが数字以外だと登録できないこと' do
        user.user_job_id = '二'
        user.valid?
        expect(user.errors).to be_added(:user_job_id, :not_a_number, value: '二')
      end
  
      it 'user_job_idが整数以外だと登録できないこと' do
        user.user_job_id = 1.5
        user.valid?
        expect(user.errors).to be_added(:user_job_id, :not_an_integer, value: 1.5)
      end
  
      it 'user_job_idが0未満だと登録できないこと' do
        user.user_job_id = 0
        user.valid?
        expect(user.errors).to be_added(:user_job_id, :greater_than_or_equal_to, count: 1, value: 0)
      end
  
      it 'user_job_idが9以上だと登録できないこと' do
        user.user_job_id = 9
        user.valid?
        expect(user.errors).to be_added(:user_job_id, :less_than_or_equal_to, count: 8, value: 9)
      end
  
      it 'プロフィール画像が5MB以上だと登録できないこと' do
        user.avatar = fixture_file_upload('5M_test.png')
        user.valid?
        expect(user.errors).to be_added(:avatar, 'ファイルのサイズは5MBまでにしてください')
      end
  
      it 'プロフィール画像の拡張子がjpg,jpeg,gif,png以外だと登録できないこと' do
        user.avatar = fixture_file_upload('test.txt')
        user.valid?
        expect(user.errors).to be_added(:avatar, 'ファイルが対応している形式ではありません')
      end
  
      context 'パスワードのバリデーションチェック' do
        it '要件通り（8文字以上でアルファベットの大文字小文字、数字）のパスワードを入力した場合' do
          user = build(:user)
          user.valid?
          expect(user).to be_valid
        end
  
        it '8文字以下の場合' do
          user = build(:user, password: 'Test12!')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '文字のみの場合' do
          user = build(:user, password: 'Testtest')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '数字のみの場合' do
          user = build(:user, password: '12345678')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '記号のみの場合' do
          user = build(:user, password: '!$%&!$%&')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '小文字を入力しない場合' do
          user = build(:user, password: 'TEST1234!')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '文字と記号のみの場合' do
          user = build(:user, password: 'Test!$%&')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
  
        it '記号と数字のみの場合' do
          user = build(:user, password: '!$%&1234')
          user.valid?
          expect(user.errors[:password]).to include('は不正な値です')
        end
      end
    end
  end
end
