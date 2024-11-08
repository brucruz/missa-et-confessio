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

  test "should have unique start_time for each day_of_week of the same church" do
    mass_schedule = MassSchedule.new(
      church: @church,
      day_of_week: @mass_schedule.day_of_week,
      start_time: @mass_schedule.start_time,
      active: true
    )
    assert_not mass_schedule.valid?

    # Should allow same time on different days
    mass_schedule.day_of_week = (mass_schedule.day_of_week + 1) % 7
    assert mass_schedule.valid?

    # Should allow same time for different churches
    mass_schedule.church = churches(:sao_joao_de_brito)
    assert mass_schedule.valid?
  end
end
