require "test_helper"

class MassSchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mass_schedules_new_url
    assert_response :success
  end

  test "should get create" do
    get mass_schedules_create_url
    assert_response :success
  end
end
