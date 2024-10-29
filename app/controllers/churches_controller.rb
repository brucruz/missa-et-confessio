class ChurchesController < ApplicationController
  def index
    @churches = Church.all.map do |church|
      church.mass_schedules = church.mass_schedules.presence || []
      church.confession_schedules = church.confession_schedules.presence || []
      church
    end
  end
end
