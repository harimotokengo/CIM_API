class Matter < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :client
  belongs_to :inquiry, optional: true
  has_many :opponents, dependent: :destroy
  # has_many :lawyer_prices, dependent: :destroy
  has_many :occurrences, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :matter_assigns, dependent: :destroy
  has_many :work_logs, dependent: :destroy
  has_many :work_details, dependent: :destroy
  has_many :folder_urls, dependent: :destroy
  has_many :matter_tags, dependent: :destroy
  has_many :tags, through: :matter_tags
  has_many :invite_urls, dependent: :destroy
  has_many :matter_joins, dependent: :destroy
  has_many :assigned_users, through: :matter_assigns, source: :user

  accepts_nested_attributes_for :opponents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :fees, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :folder_urls, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :matter_joins, reject_if: :all_blank, allow_destroy: true
end
