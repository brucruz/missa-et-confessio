class MassSchedulesController < ApplicationController
  def new
    @church = Church.find(params[:church_id])
    @days = I18n.t("date.day_names").each_with_index.map { |name, index| [ name, index ] }

    # Initialize existing schedules
    @mass_schedules = @days.map do |name, wday|
      existing = @church.mass_schedules.find_by(day_of_week: wday)
      existing || @church.mass_schedules.new(day_of_week: wday, active: false)
    end
  end

  def create
    @church = Church.find(params[:church_id])

    ActiveRecord::Base.transaction do
      # First, deactivate all existing schedules
      @church.mass_schedules.update_all(active: false)

      # Then create or update the new schedules
      mass_schedule_params[:schedules_attributes].each do |schedule_params|
        next if schedule_params[:start_time].blank?

        schedule = @church.mass_schedules.find_or_initialize_by(
          day_of_week: schedule_params[:day_of_week]
        )

        schedule.update!(
          start_time: schedule_params[:start_time],
          active: true
        )
      end
    end

    redirect_to new_church_confession_schedule_path(@church),
      notice: "Horários de missa adicionados com sucesso. Agora adicione os horários de confissão."
  end

  private

  def mass_schedule_params
    params.require(:mass_schedules).permit(schedules_attributes: [ :active, :day_of_week, :start_time ])
  end
end
