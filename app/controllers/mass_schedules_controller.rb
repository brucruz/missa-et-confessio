class MassSchedulesController < ApplicationController
  def new
    @church = Church.find(params[:church_id])
    @mass_schedule = @church.mass_schedules.new
  end

  def create
  end
end
