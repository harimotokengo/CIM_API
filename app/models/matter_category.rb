class MatterCategory < ApplicationRecord
  has_many :matter_category_joins
  has_ancestry
end
