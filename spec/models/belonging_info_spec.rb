require 'rails_helper'

RSpec.describe BelongingInfo, type: :model do
  let!(:belonging_info) { create(:belonging_info) }

  describe 'validates' do
    context '正常系' do
      it '有効なファクトリを持つこと' do
        expect(belonging_info).to be_valid
      end
    end

    context '準正常系' do
      it 'default_priceが数字以外の場合登録出来ない' do
        belonging_info.default_price = '三千'
        belonging_info.valid?
        expect(belonging_info.errors).to be_added(:default_price, :not_a_number, value: '三千')
      end
    end
  end
end
