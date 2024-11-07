require "test_helper"

class MassSchedulesHelperTest < ActionView::TestCase
  include MassSchedulesHelper

  def test_format_time_in_local_timezone_with_valid_time
    time = Time.new(2022, 1, 1, 12, 0, 0)
    timezone = "Eastern Time (US & Canada)"
    assert_equal "07:00", format_time_in_local_timezone(time, timezone)
  end

  def test_format_time_in_local_timezone_with_valid_time_sao_paulo
    time = Time.new(2022, 1, 1, 12, 0, 0)
    timezone = "America/Sao_Paulo"
    assert_equal "09:00", format_time_in_local_timezone(time, timezone)
  end

  def test_format_time_in_local_timezone_with_blank_time
    time = nil
    timezone = "Eastern Time (US & Canada)"
    assert_nil format_time_in_local_timezone(time, timezone)
  end

  def test_format_time_in_local_timezone_with_blank_time_sao_paulo
    time = nil
    timezone = "America/Sao_Paulo"
    assert_nil format_time_in_local_timezone(time, timezone)
  end
end
