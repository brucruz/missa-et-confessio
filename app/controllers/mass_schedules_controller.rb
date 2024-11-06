class MassSchedulesController < ApplicationController
  def new
    @church = Church.find(params[:church_id])
    @days = I18n.t("date.day_names").each_with_index.map { |name, index| [ name, index ] }
    @mass_schedules = initialize_mass_schedules
  end

  def create
    @church = Church.find(params[:church_id])

    if @church.mass_schedules.exists?
      redirect_to edit_church_mass_schedule_path(@church)
      return
    end

    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa adicionados com sucesso."
  end

  def edit
    @church = Church.find(params[:church_id])
    @days = I18n.t("date.day_names").each_with_index.map { |name, index| [ name, index ] }
    @mass_schedules = initialize_mass_schedules
  end

  def update
    @church = Church.find(params[:church_id])
    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa atualizados com sucesso."
  end

  def index
    @church = Church.find(params[:church_id])
    @mass_schedules = @church.mass_schedules.where(active: true).group_by(&:day_of_week)
  end

  private

  def initialize_mass_schedules
    @days.map do |name, wday|
      existing = @church.mass_schedules.find_by(day_of_week: wday)
      existing || @church.mass_schedules.new(day_of_week: wday, active: false)
    end
  end

  def save_mass_schedules
    ActiveRecord::Base.transaction do
      # First, deactivate all existing schedules
      @church.mass_schedules.update_all(active: false)

      # Then create or update the new schedules
      mass_schedule_params[:schedules_attributes].each do |schedule_params|
        schedule_params_values = schedule_params.last
        next if schedule_params_values[:start_time].blank?

        schedule = @church.mass_schedules.find_or_initialize_by(
          day_of_week: schedule_params_values[:day_of_week]
        )

        # Convert local time to UTC based on church's timezone
        local_time = Time.parse(schedule_params_values[:start_time])
        utc_time = ActiveSupport::TimeZone[@church.timezone].local_to_utc(local_time)

        schedule.update!(
          start_time: utc_time,
          active: true
        )
      end
    end
  end

  def mass_schedule_params
    params.require(:mass_schedules).permit(schedules_attributes: [ :active, :day_of_week, :start_time ])
  end
end
