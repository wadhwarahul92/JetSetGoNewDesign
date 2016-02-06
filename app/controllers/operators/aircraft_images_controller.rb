class Operators::AircraftImagesController < Operators::BaseController

  before_action :authenticate_operator

  before_action :set_aircraft

  before_action :set_aircraft_image, only: [:destroy]

  def create
    @aircraft_image = @aircraft.aircraft_images.new(image: params[:file])
    if @aircraft_image.save
      render status: :ok, json: { id: @aircraft_image.id, url: @aircraft_image.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @aircraft_image.errors.full_messages }
    end
  end

  def destroy
    if @aircraft_image.destroy
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  private

  def set_aircraft
    @aircraft = Aircraft.find params[:aircraft_id]
  end

  def set_aircraft_image
    @aircraft_image = @aircraft.aircraft_images.find params[:id]
  end

end