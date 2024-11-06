module MassSchedulesHelper
  def format_time(time, timezone)
    Time.zone.today.beginning_of_day.change(hour: time.hour, min: time.min).in_time_zone(timezone).strftime("%H:%M")
  end
end
