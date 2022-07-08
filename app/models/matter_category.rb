class MatterCategory < ApplicationRecord
  has_many :matters
  has_ancestry
end
