module ChurchesHelper
  def distance_to_human(distance_in_km)
    return nil if distance_in_km.nil?

    if distance_in_km >= 1
      "#{distance_in_km.round(1)} km"
    else
      "#{(distance_in_km * 1000).round} m"
    end
  end
end
