class MatterCategoryJoin < ApplicationRecord
  belongs_to :matter
  belongs_to :matter_category
end
