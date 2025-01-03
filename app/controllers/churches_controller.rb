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

  def new
    @church = Church.new
  end

  def create
    @church = Church.find_or_initialize_by(place_id: church_params[:place_id]) do |church|
      church.assign_attributes(church_params)
    end

    if @church.save
      redirect_to church_path(@church), notice: "#{@church.previously_new_record? ? "Igreja criada com sucesso" : "Igreja já existe"}, adicione agora os horários de missas."
    else
      render :new, status: :unprocessable_entity, alert: "Erro ao criar igreja, tente novamente."
    end
  end

  def show
    @church = Church.find(params[:id])
    @mass_schedules = @church.mass_schedules.where(active: true)
                                            .order(:day_of_week, :start_time)
                                            .group_by(&:day_of_week)
  end

  private

  def church_params
    params.require(:church).permit(:name, :address, :place_id)
  end
end
