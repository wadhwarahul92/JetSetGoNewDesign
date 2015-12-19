class Admin::AircraftTypesController < Admin::BaseController

  after_filter :authenticate_admin

  def index
    @aircraft_types = AircraftType.all
  end

end