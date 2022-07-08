class BelongingInfo < ApplicationRecord
  belongs_to :user
  belongs_to :office

  scope :belonging, -> { where(status_id: 1) }
  scope :belonged, -> { where(status_id: 2) }

  validates :default_price,
            numericality: {
              only_integer: true
              # greater_than_or_equal_to: 1,
              # less_than_or_equal_to: 8,
            },
            allow_blank: true

  enum status_id: {
    所属: 1, 退所: 2
  }

  enum user_job_id: {
    弁護士: 1,  司法書士: 2,
    行政書士: 3, 社労士: 4, 
    税理士: 5,  弁理士: 6,
    会計士: 7,  その他: 8
  }
end
