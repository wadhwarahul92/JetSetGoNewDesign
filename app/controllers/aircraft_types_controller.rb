class AircraftTypesController < ApplicationController

  before_action :set_aircraft_type

  def show
    sleep 2
  end

  private

  def set_aircraft_type
    @aircraft_type = AircraftType.find params[:id]
  end

end