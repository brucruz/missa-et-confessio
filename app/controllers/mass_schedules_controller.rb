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

  def edit
    @mass_schedules = @church.mass_schedules.order(:day_of_week, :start_time).to_a
    # Fill in empty days with new records
    (0..6).each do |day|
      unless @mass_schedules.any? { |s| s.day_of_week == day }
        @mass_schedules << MassSchedule.new(day_of_week: day, active: false)
      end
    end
    @mass_schedules.sort_by!(&:day_of_week)
    @next_schedule_index = @mass_schedules.size # Track next available index
  end

  def bulk_update
    Rails.logger.debug "Params: #{params.inspect}"
    Rails.logger.debug "Mass schedules params: #{params[:mass_schedules].inspect}"
    Rails.logger.debug "Schedules params: #{params[:mass_schedules][:schedules].inspect}"

    save_mass_schedules

    redirect_to church_path(@church),
      notice: "Horários de missa atualizados com sucesso."
  end

  def index
    @mass_schedules = @church.mass_schedules.where(active: true).group_by(&:day_of_week)
  end

  def add_schedule
    @new_schedule = MassSchedule.new(
      day_of_week: params[:day_of_week],
      active: true
    )
    @next_schedule_index = params[:next_index].to_i

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

  # def initialize_mass_schedules
  #   @days.each_with_object({}) do |(name, wday), schedules|
  #     existing = @church.mass_schedules.where(day_of_week: wday)
  #     schedules[wday] = existing.any? ? existing : [ @church.mass_schedules.new(day_of_week: wday, active: false) ]
  #   end
  # end
  def initialize_mass_schedules
    @days.each do |name, wday|
      existing = @church.mass_schedules.where(day_of_week: wday)
      existing.any? ? existing : @church.mass_schedules.new(day_of_week: wday, active: false)
    end
    @church
          .mass_schedules
          .sort_by { |schedule| [ schedule.day_of_week, schedule.start_time ] }
  end

  def save_mass_schedules
    ActiveRecord::Base.transaction do
      bulk_update_params[:schedules].values.each do |schedule_params|
        if schedule_params[:start_time].present?
          # Convert time to UTC based on church's timezone
          local_time = Time.parse(schedule_params[:start_time])
          utc_time = local_time.in_time_zone(@church.timezone).utc

          # Find by id if present, otherwise find or initialize by time and day
          schedule = if schedule_params[:id].present?
            @church.mass_schedules.find(schedule_params[:id])
          else
            @church.mass_schedules.find_or_initialize_by(
              day_of_week: schedule_params[:day_of_week],
              start_time: utc_time
            )
          end

          schedule.assign_attributes(
            day_of_week: schedule_params[:day_of_week],
            start_time: utc_time,
            active: schedule_params[:active] == "1" ? true : false
          )
          if schedule.save
          else
            debugger
            Rails.logger.error schedule.errors.full_messages.to_sentence
          end
        end
      end

      # Clean up any schedules that weren't in the form
      valid_times = bulk_update_params[:schedules].values
                     .select { |s| s[:start_time].present? }
                     .map { |s| Time.parse(s[:start_time]).in_time_zone(@church.timezone).utc }

      @church.mass_schedules.where.not(start_time: valid_times).destroy_all
    end
  end

  def bulk_update_params
    params.require(:mass_schedules).permit(schedules: [ :id, :active, :day_of_week, :start_time ])
  end

  def mass_schedule_params
    params.require(:mass_schedules).permit(schedules: [ :active, :day_of_week, :start_time ])
  end
end
