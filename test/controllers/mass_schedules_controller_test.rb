require "test_helper"

class MassSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @church_with_mass_schedules = churches(:santo_antonio_de_piracicaba)
    @church_without_mass_schedules = churches(:sao_joao_de_brito)
  end

  test "should get new" do
    get new_church_mass_schedule_url(@church_with_mass_schedules)
    assert_response :success
  end

  test "should create mass schedules" do
    assert_difference("MassSchedule.count", 2) do
      post church_mass_schedules_url(@church_without_mass_schedules), params: {
        mass_schedules: {
          schedules: [
            { day_of_week: "0", start_time: "08:00", active: "true" },
            { day_of_week: "1", start_time: "19:00", active: "true" }
          ]
        }
      }
    end

    assert_redirected_to church_url(@church_without_mass_schedules)
    assert_equal "Horários de missa adicionados com sucesso.", flash[:notice]
  end

  # TODO: Fix edit mass_schedules tests - they are not working because mass_schedule_id is missing
  # test "should redirect to edit if mass schedules exist" do
  #   post church_mass_schedules_url(@church_with_mass_schedules, 1), params: {
  #     mass_schedules: {
  #       schedules: [
  #         { day_of_week: 0, start_time: "08:00", active: true }
  #       ]
  #     }
  #   }

  #   assert_redirected_to edit_church_mass_schedule_url(@church_with_mass_schedules)
  # end

  # test "should get edit" do
  #   get edit_church_mass_schedule_url(@church_with_mass_schedules)
  #   assert_response :success
  # end

  # test "should update mass schedules" do
  #   put church_mass_schedule_url(@church_with_mass_schedules), params: {
  #     mass_schedules: {
  #       schedules_attributes: {
  #         "0" => { day_of_week: 0, start_time: "09:00", active: true },
  #         "1" => { day_of_week: 2, start_time: "20:00", active: true }
  #       }
  #     }
  #   }

  #   assert_redirected_to church_url(@church_with_mass_schedules)
  #   assert_equal "Horários de missa atualizados com sucesso.", flash[:notice]
  # end
end
