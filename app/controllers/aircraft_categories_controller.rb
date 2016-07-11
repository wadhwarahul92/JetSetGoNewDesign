class AircraftCategoriesController < ApplicationController

  def index
    @aircraft_categories  = AircraftCategory.all
  end

end