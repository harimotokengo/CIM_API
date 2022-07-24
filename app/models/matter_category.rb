class MatterCategory < ApplicationRecord
  has_many :matter_category_joins
  has_many :task_template_groups
  has_ancestry
end
