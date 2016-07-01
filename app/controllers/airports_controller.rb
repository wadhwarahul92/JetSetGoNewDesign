class AirportsController < ApplicationController

  def index
    @airports = Airport.order('name ASC').includes(:city).all
  end

  def all_names
    @airport_names = Airport.order('name ASC').all.map(&:name)
    render json: @airport_names.to_json
  end

end