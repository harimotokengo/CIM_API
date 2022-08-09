class FolderUrl < ApplicationRecord
  belongs_to :matter
  # has_many :edit_logs, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :url
  end
end
