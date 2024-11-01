class Church < ApplicationRecord
  has_many :mass_schedules, dependent: :destroy
  has_many :confession_schedules, dependent: :destroy

  validates :name, :address, :place_id, presence: true
  validates :place_id, uniqueness: true

  after_validation :geocode, if: -> { address_changed? }
  after_validation :set_timezone, if: -> { latitude_changed? || longitude_changed? }

  geocoded_by :address do |church, results|
    if geo = results.first
      state_component = geo.address_components_of_type(:administrative_area_level_1).first
      city_component = geo.address_components_of_type(:administrative_area_level_2).first
      neighborhood_component = geo.address_components_of_type(:sublocality_level_1).first

      if state_component
        state = state_component["long_name"]
          .gsub("State of ", "")
          .gsub("Estado de ", "")
      end
      # uf = state_component["short_name"] if state_component
      city = city_component["long_name"] if city_component
      neighborhood = neighborhood_component["long_name"] if neighborhood_component

      church.state = state
      church.city = city
      church.neighborhood = neighborhood
      church.country = geo.country
      church.latitude = geo.latitude
      church.longitude = geo.longitude
    end
  end

  def set_timezone
    self.timezone = Timezone.lookup(latitude, longitude).name if latitude.present? && longitude.present?
  end
end
