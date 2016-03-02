class AircraftsController < ApplicationController

  def index
    @aircrafts = Aircraft.where(id: params[:ids]).includes(:aircraft_images, :aircraft_type, :base_airport)
  end

end