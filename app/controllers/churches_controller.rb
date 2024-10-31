class ChurchesController < ApplicationController
  def index
    @location = params[:location]
    @churches = if @location.present?
      Church.near(@location, 10)
    else
      Church.all
    end

    @churches = @churches.map do |church|
      church.mass_schedules = church.mass_schedules.presence || []
      church.confession_schedules = church.confession_schedules.presence || []
      church
    end
  end
end
