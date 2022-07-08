class Tag < ApplicationRecord
  has_many :matter_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :matters, through: :matter_tags
  
  validates :tag_name,
            presence: true,
            uniqueness: { case_sensitive: true },
            length: { maximum: 100 }
end
