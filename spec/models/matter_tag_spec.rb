require 'rails_helper'

RSpec.describe MatterTag, type: :model do
  let!(:tag) { create(:tag) }
  let!(:matter) { create(:matter) }
  let!(:matter_tag) { create(:matter_tag, tag: tag, matter: matter) }

  describe 'validates' do
    context '正常系' do
      it '有効なファクトリを持つこと' do
        expect(matter_tag).to be_valid
      end
    end
    context '準正常系' do
      it 'タグがない場合、無効なこと' do
        matter_tag.tag = nil
        matter_tag.valid?
        expect(matter_tag.errors).to be_added(:tag, :blank)
      end
      it '案件がない場合、無効なこと' do
        matter_tag.matter = nil
        matter_tag.valid?
        expect(matter_tag.errors).to be_added(:matter, :blank)
      end
    end
  end
end
