module MassSchedulesHelper
  def format_time_in_local_timezone(time, timezone)
    return if time.blank?

    Time.zone.today.beginning_of_day.change(hour: time.hour, min: time.min).in_time_zone(timezone).strftime("%H:%M")
  end
end
