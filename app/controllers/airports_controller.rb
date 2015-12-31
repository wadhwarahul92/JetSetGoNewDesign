class AirportsController < ApplicationController

  def index
    @airports = Airport.includes(:city).all
  end

end