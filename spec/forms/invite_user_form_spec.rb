require 'rails_helper'

RSpec.describe 'InviteUserForm', type: :model do

  # createでfactoryを呼び出すとsave!されるのでbuildとsaveを分ける
  before :each do
    @invite_user_form = FactoryBot.build(:invite_user_form)
  end

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(@invite_user_form).to be_valid
    end

    it 'last_nameがない場合は登録できないこと' do
      @invite_user_form.last_name = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:last_name, :blank)
    end

    it 'last_nameが15文字以内の場合は登録できること' do
      @invite_user_form.last_name = 'a' * 15
      expect(@invite_user_form).to be_valid
    end

    it 'last_nameが16文字以上の場合は登録できないこと' do
      @invite_user_form.last_name = 'a' * 16
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:last_name, :too_long, count: 15)
    end

    it 'first_nameがない場合は登録できないこと' do
      @invite_user_form.first_name = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:first_name, :blank)
    end

    it 'first_nameが15文字以上の場合は登録できないこと' do
      @invite_user_form.first_name = 'a' * 15
      expect(@invite_user_form).to be_valid
    end

    it 'first_nameが16文字以上の場合は登録できないこと' do
      @invite_user_form.first_name = 'a' * 16
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:first_name, :too_long, count: 15)
    end

    it 'emailがない場合は登録できないこと' do
      @invite_user_form.email = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:email, :blank)
    end

    it 'emailがユニークでない場合は登録できないこと' do
      @invite_user_form.save
      @invite_user_form2 = FactoryBot.build(:invite_user_form)
      @invite_user_form2.email = @invite_user_form.email
      @invite_user_form2.valid?
      expect(@invite_user_form2.errors).to be_added(:email, :taken)
    end

    it 'first_name_kanaが無いと登録できないこと' do
      @invite_user_form.first_name_kana = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:first_name_kana, :blank)
    end

    it 'first_name_kanaが15文字以内なら登録できること' do
      @invite_user_form.first_name_kana = 'あ' * 15
      expect(@invite_user_form).to be_valid
    end

    it 'first_name_kanaが16文字以上なら登録できないこと' do
      @invite_user_form.first_name_kana = 'あ' * 16
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:first_name_kana, :too_long, count: 15)
    end

    it 'first_name_kanaが全角ひらがな以外は登録できないこと' do
      @invite_user_form.first_name_kana = 'テスト'
      @invite_user_form.valid?
      expect(@invite_user_form.errors[:first_name_kana]).to include 'は全角ひらがなで入力して下さい'
    end

    it 'user_job_idが無いと登録できないこと' do
      @invite_user_form.user_job_id = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:user_job_id, :blank)
    end

    it 'user_job_idが数字以外だと登録できないこと' do
      @invite_user_form.user_job_id = '二'
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:user_job_id, :not_a_number, value: '二')
    end

    it 'user_job_idが整数以外だと登録できないこと' do
      @invite_user_form.user_job_id = 1.5
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:user_job_id, :not_an_integer, value: 1.5)
    end

    it 'user_job_idが0未満だと登録できないこと' do
      @invite_user_form.user_job_id = 0
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:user_job_id, :greater_than_or_equal_to, count: 1, value: 0)
    end

    it 'user_job_idが9以上だと登録できないこと' do
      @invite_user_form.user_job_id = 9
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:user_job_id, :less_than_or_equal_to, count: 8, value: 9)
    end

    it 'user_status_idが無いと登録できないこと' do
      @invite_user_form.status_id = nil
      @invite_user_form.valid?
      expect(@invite_user_form.errors).to be_added(:status_id, :blank)
    end
  end
end
