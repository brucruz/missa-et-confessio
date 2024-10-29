class Church < ApplicationRecord
  has_many :mass_schedules, dependent: :destroy
  has_many :confession_schedules, dependent: :destroy
end
