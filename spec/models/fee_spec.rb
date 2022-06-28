require 'rails_helper'

RSpec.describe Fee, type: :model do
  let!(:fee) { create(:fee) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(fee).to be_valid
    end
    # matter
    xit '案件と問い合わせがない場合無効であること' do
      fee.matter_id = nil
      fee.inquiry_id = nil
      fee.valid?
      expect(fee.errors).to be_added(:matter, :blank)
    end
    # fee_type_id
    it 'fee_type_idがない場合無効であること' do
      fee.fee_type_id = nil
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :blank)
    end
    xit 'fee_type_idが数字以外だと登録できないこと' do
      fee.fee_type_id = '二'
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :not_a_number, value: '二')
    end
    xit 'fee_type_idが整数以外だと登録できないこと' do
      fee.fee_type_id = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :not_an_integer, value: 1.5)
    end
    xit 'fee_type_idが0だと登録できないこと' do
      fee.fee_type_id = 0
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :greater_than_or_equal_to, count: 1, value: 0)
    end
    xit 'fee_type_idが0未満だと登録できないこと' do
      fee.fee_type_id = -1
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :greater_than_or_equal_to, count: 1, value: -1)
    end
    xit 'fee_type_idが8以上だと登録できないこと' do
      fee.fee_type_id = 8
      fee.valid?
      expect(fee.errors).to be_added(:fee_type_id, :less_than_or_equal_to, count: 7, value: 8)
    end
    # price
    it 'priceがない場合無効であること' do
      fee.price = nil
      fee.valid?
      expect(fee.errors).to be_added(:price, :blank)
    end
    it 'priceが数字以外だと登録できないこと' do
      fee.price = '二'
      fee.valid?
      expect(fee.errors).to be_added(:price, :not_a_number, value: '二')
    end
    it 'priceが整数以外だと登録できないこと' do
      fee.price = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:price, :not_an_integer, value: 1.5)
    end
    it 'priceが0未満だと登録できないこと' do
      fee.price = -1
      fee.valid?
      expect(fee.errors).to be_added(:price, :greater_than_or_equal_to, count: 0, value: -1)
    end
    # description
    it 'descriptionがなくても有効であること' do
      fee.description = nil
      expect(fee).to be_valid
    end
    # deadline
    it 'deadlineがなくても有効であること' do
      fee.deadline = nil
      expect(fee).to be_valid
    end
    xit 'deadlineが日付以外の場合無効であること' do
      fee.deadline = 'test'
      fee.valid?
      expect(fee.errors).to be_added(:deadline, value: 'test')
    end
    # pay_times
    it 'pay_timesがない場合無効であること' do
      fee.pay_times = nil
      fee.valid?
      expect(fee.errors).to be_added(:pay_times, :blank)
    end
    it 'pay_timesが数字以外だと登録できないこと' do
      fee.pay_times = '二'
      fee.valid?
      expect(fee.errors).to be_added(:pay_times, :not_a_number, value: '二')
    end
    it 'pay_timesが整数以外だと登録できないこと' do
      fee.pay_times = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:pay_times, :not_an_integer, value: 1.5)
    end
    it 'pay_timesが1未満だと登録できないこと' do
      fee.pay_times = -1
      fee.valid?
      expect(fee.errors).to be_added(:pay_times, :greater_than_or_equal_to, count: 1, value: -1)
    end
    # monthly_date_id
    it 'monthly_date_idがない場合有効であること' do
      fee.monthly_date_id = nil
      expect(fee).to be_valid
    end
    it 'monthly_date_idが数字以外だと登録できないこと' do
      fee.monthly_date_id = '二'
      fee.valid?
      expect(fee.errors).to be_added(:monthly_date_id, :not_a_number, value: '二')
    end
    it 'monthly_date_idが整数以外だと登録できないこと' do
      fee.monthly_date_id = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:monthly_date_id, :not_an_integer, value: 1.5)
    end
    it 'monthly_date_idが0だと登録できないこと' do
      fee.monthly_date_id = 0
      fee.valid?
      expect(fee.errors).to be_added(:monthly_date_id, :greater_than_or_equal_to, count: 1, value: 0)
    end
    it 'monthly_date_idが0未満だと登録できないこと' do
      fee.monthly_date_id = -1
      fee.valid?
      expect(fee.errors).to be_added(:monthly_date_id, :greater_than_or_equal_to, count: 1, value: -1)
    end
    it 'monthly_date_idが32以上だと登録できないこと' do
      fee.monthly_date_id = 32
      fee.valid?
      expect(fee.errors).to be_added(:monthly_date_id, :less_than_or_equal_to, count: 31, value: 32)
    end
    # current_payment
    it 'current_paymentがない場合有効であること' do
      fee.current_payment = nil
      expect(fee).to be_valid
    end
    it 'current_paymentが数字以外だと登録できないこと' do
      fee.current_payment = '二'
      fee.valid?
      expect(fee.errors).to be_added(:current_payment, :not_a_number, value: '二')
    end
    it 'current_paymentが整数以外だと登録できないこと' do
      fee.current_payment = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:current_payment, :not_an_integer, value: 1.5)
    end
    it 'current_paymentが0未満だと登録できないこと' do
      fee.current_payment = -1
      fee.valid?
      expect(fee.errors).to be_added(:current_payment, :greater_than_or_equal_to, count: 0, value: -1)
    end
    # paid_date
    it 'paid_dateがなくても有効であること' do
      fee.paid_date = nil
      expect(fee).to be_valid
    end
    # paid_amount
    it 'paid_amountがない場合有効であること' do
      fee.paid_amount = nil
      expect(fee).to be_valid
    end
    it 'paid_amountが数字以外だと登録できないこと' do
      fee.paid_amount = '二'
      fee.valid?
      expect(fee.errors).to be_added(:paid_amount, :not_a_number, value: '二')
    end
    it 'paid_amountが整数以外だと登録できないこと' do
      fee.paid_amount = 1.5
      fee.valid?
      expect(fee.errors).to be_added(:paid_amount, :not_an_integer, value: 1.5)
    end
    it 'paid_amountが0未満だと登録できないこと' do
      fee.paid_amount = -1
      fee.valid?
      expect(fee.errors).to be_added(:paid_amount, :greater_than_or_equal_to, count: 0, value: -1)
    end
    # pay_off
    it 'pay_offがnilの場合無効であること' do
      fee.pay_off = nil
      fee.valid?
      expect(fee.errors).to be_added(:pay_off, :inclusion, value: nil)
    end
  end
end
