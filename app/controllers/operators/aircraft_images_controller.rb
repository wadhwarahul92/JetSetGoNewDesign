class Operators::AircraftImagesController < Operators::BaseController

  before_action :authenticate_operator

  before_action :set_aircraft

  def create
    @aircraft_image = @aircaft.aircraft_images.new(image: params[:file])
    if @aircraft_image.save
      render status: :ok, json: { aircraft_image: @aircraft_image.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @aircraft_image.errors.full_messages }
    end
  end

  private

  def set_aircraft
    @aircaft = Aircraft.find params[:aircraft_id]
  end

end