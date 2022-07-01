class MatterCategory < ApplicationRecord
  has_many :items
  has_ancestry
end
