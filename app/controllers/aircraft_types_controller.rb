class AircraftTypesController < ApplicationController

  before_action :set_aircraft_type, only: [:show]

  def index
    @aircraft_types = AircraftType.all
  end

  def show

  end

  private

  def set_aircraft_type
    @aircraft_type = AircraftType.find params[:id]
  end

end