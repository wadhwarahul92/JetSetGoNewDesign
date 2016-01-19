class AirportsController < ApplicationController

  def index
    @airports = Airport.includes(:city).all
  end

  def all_names
    @airport_names = Airport.all.map(&:name)
    render json: @airport_names.to_json
  end

end