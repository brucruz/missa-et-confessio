class MassSchedule < ApplicationRecord
  belongs_to :church, optional: false

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :start_time, presence: true
  validates :start_time, uniqueness: { scope: [ :church_id, :day_of_week ] }
  validates :active, inclusion: { in: [ true, false ] }
end
