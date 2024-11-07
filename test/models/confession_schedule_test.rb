require "test_helper"

class ConfessionScheduleTest < ActiveSupport::TestCase
  setup do
    @church = churches(:santo_antonio_de_piracicaba)
    @confession_schedule = confession_schedules(:one)
  end

  test "should be valid with all required attributes" do
    assert @confession_schedule.valid?
  end

  test "should belong to church" do
    assert_equal @church, @confession_schedule.church
  end

  test "should require church" do
    @confession_schedule.church = nil
    assert_not @confession_schedule.valid?
  end

  test "should require day_of_week" do
    @confession_schedule.day_of_week = nil
    assert_not @confession_schedule.valid?
  end

  test "should validate day_of_week is between 0 and 6" do
    @confession_schedule.day_of_week = 7
    assert_not @confession_schedule.valid?

    @confession_schedule.day_of_week = -1
    assert_not @confession_schedule.valid?
  end

  test "should require start_time" do
    @confession_schedule.start_time = nil
    assert_not @confession_schedule.valid?
  end

  test "should require active" do
    @confession_schedule.active = nil
    assert_not @confession_schedule.valid?
  end

  test "should allow end_time to be nil" do
    @confession_schedule.end_time = nil
    assert @confession_schedule.valid?
  end
end
