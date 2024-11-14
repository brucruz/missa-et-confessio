class MassSchedulesController < ApplicationController
  before_action :set_church
  before_action :set_days, :set_mass_schedules, only: [ :new, :edit, :add_schedule ]

  def new; end

  def create
    if @church.mass_schedules.exists?
      redirect_to edit_church_mass_schedule_path(@church)
      return
    end

    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa adicionados com sucesso."
  end

  def edit; end

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
    # @mass_schedules =
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

  def set_mass_schedules
    @mass_schedules = initialize_mass_schedules
  end

  def initialize_mass_schedules
    @days.each_with_object({}) do |(name, wday), schedules|
      existing = @church.mass_schedules.where(day_of_week: wday)
      schedules[wday] = existing.any? ? existing : [ @church.mass_schedules.new(day_of_week: wday, active: false) ]
    end
  end

  def save_mass_schedules
    ActiveRecord::Base.transaction do
      # Group schedules by day_of_week
      schedules_by_day = mass_schedule_params[:schedules].group_by { |s| s[:day_of_week] }

      schedules_by_day.each do |day_of_week, day_schedules|
        # Get all schedules for this day that have a start time
        valid_schedules = day_schedules.reject { |s| s[:start_time].blank? }

        # Delete existing schedules for this day
        @church.mass_schedules.where(day_of_week: day_of_week).destroy_all if valid_schedules.any?

        # Create new schedules for each start time
        valid_schedules.each do |schedule_params|
          # Convert local time to UTC based on church's timezone
          local_time = Time.parse(schedule_params[:start_time])
          utc_time = ActiveSupport::TimeZone[@church.timezone].local_to_utc(local_time)

          @church.mass_schedules.create!(
            start_time: utc_time,
            day_of_week: schedule_params[:day_of_week],
            active: schedule_params[:active]
          )
        end
      end
    end
  end

  def mass_schedule_params
    params.require(:mass_schedules).permit(schedules: [ :active, :day_of_week, :start_time ])
  end
end
