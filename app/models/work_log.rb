class WorkLog < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :matter, optional: true
  belongs_to :fee, optional: true
  # has_many :edit_logs, dependent: :destroy

  accepts_nested_attributes_for :fee

  with_options presence: true do
    validates :worked_date
    validates :content
    validates :user_id
  end
  validates :detail_reflection, inclusion: { in: [true, false] }
  validates :working_time,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_blank: true
end
