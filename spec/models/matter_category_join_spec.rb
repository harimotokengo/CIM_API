require 'rails_helper'

RSpec.describe MatterCategoryJoin, type: :model do
  let!(:matter_category_join) { create(:matter_category_join) }

  describe 'validates' do
    it '有効なファクトリを持つこと' do
      expect(matter_category_join).to be_valid
    end
  end
end
