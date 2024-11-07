class MassSchedulesController < ApplicationController
  before_action :set_church
  before_action :set_days, only: [ :new, :edit, :add_schedule ]

  def new
    @mass_schedules = initialize_mass_schedules
  end

  def create
    if @church.mass_schedules.exists?
      redirect_to edit_church_mass_schedule_path(@church)
      return
    end

    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa adicionados com sucesso."
  end

  def edit
    @mass_schedules = initialize_mass_schedules
  end

  def update
    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa atualizados com sucesso."
  end

  def index
    @mass_schedules = @church.mass_schedules.where(active: true).group_by(&:day_of_week)
  end

  def add_schedule
    day_of_week = params[:day_of_week].to_i
    @new_schedule = @church.mass_schedules.new(day_of_week: day_of_week, active: false)
    @index = params[:index].to_i
    @target_dom_id = params[:target_dom_id]

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_church
    @church = Church.find(params[:church_id])
  end

  def set_days
    @days = I18n.t("date.day_names").each_with_index.map { |name, index| [ name, index ] }
  end

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
