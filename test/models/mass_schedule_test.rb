require "test_helper"

class MassScheduleTest < ActiveSupport::TestCase
  setup do
    @church = churches(:santo_antonio_de_piracicaba)
    @mass_schedule = mass_schedules(:one)
  end

  test "should be valid with all required attributes" do
    assert @mass_schedule.valid?
  end

  test "should belong to church" do
    assert_equal @church, @mass_schedule.church
  end

  test "should require church" do
    @mass_schedule.church = nil
    assert_not @mass_schedule.valid?
  end

  test "should require day_of_week" do
    @mass_schedule.day_of_week = nil
    assert_not @mass_schedule.valid?
  end

  test "should validate day_of_week is between 0 and 6" do
    @mass_schedule.day_of_week = 7
    assert_not @mass_schedule.valid?

    @mass_schedule.day_of_week = -1
    assert_not @mass_schedule.valid?
  end

  test "should require start_time" do
    @mass_schedule.start_time = nil
    assert_not @mass_schedule.valid?
  end

  test "should require active" do
    @mass_schedule.active = nil
    assert_not @mass_schedule.valid?
  end
end
