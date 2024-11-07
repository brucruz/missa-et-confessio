class MassSchedule < ApplicationRecord
  belongs_to :church, optional: false

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :start_time, :active, presence: true
end
