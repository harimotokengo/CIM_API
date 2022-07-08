require 'rails_helper'

RSpec.describe Tag, type: :model do
  let!(:tag) { create(:tag) }
  let!(:other_tag) { create(:tag, tag_name: 'その他') }
  describe 'validates' do
    context '正常系' do
      it '有効なファクトリを持つこと' do
        expect(tag).to be_valid
      end
    end
    context '準正常系' do
      it 'タグがない場合、無効なこと' do
        tag.tag_name = nil
        tag.valid?
        expect(tag.errors).to be_added(:tag_name, :blank)
      end
      it 'タグが一意でない場合、無効なこと' do
        other_tag.tag_name = tag.tag_name
        other_tag.valid?
        expect(other_tag.errors).to be_added(:tag_name, :taken, value: other_tag.tag_name)
      end
      it 'タグが101文字以上の場合、無効なこと' do
        tag.tag_name = 'a' * 101
        tag.valid?
        expect(tag.errors).to be_added(:tag_name, :too_long, count: 100)
      end
    end
  end
end
