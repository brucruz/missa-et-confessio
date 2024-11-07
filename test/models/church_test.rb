require "test_helper"

class ChurchTest < ActiveSupport::TestCase
  def setup
    @church = churches(:santo_antonio_de_piracicaba)
  end

  test "should be valid" do
    assert @church.valid?
  end

  test "name should be present" do
    @church.name = ""
    assert_not @church.valid?
  end

  test "address should be present" do
    @church.address = ""
    assert_not @church.valid?
  end

  test "place_id should be present" do
    @church.place_id = ""
    assert_not @church.valid?
  end

  test "place_id should be unique" do
    duplicate_church = @church.dup
    duplicate_church.place_id = @church.place_id
    assert_not duplicate_church.valid?
  end

  test "should have many mass_schedules" do
    assert_respond_to @church, :mass_schedules
    assert_equal 2, @church.mass_schedules.count
  end

  test "should have many confession_schedules" do
    assert_respond_to @church, :confession_schedules
    assert_equal 2, @church.confession_schedules.count
  end

  test "should destroy associated mass_schedules" do
    assert_difference "MassSchedule.count", -2 do
      @church.destroy
    end
  end

  test "should destroy associated confession_schedules" do
    assert_difference "ConfessionSchedule.count", -2 do
      @church.destroy
    end
  end
end
