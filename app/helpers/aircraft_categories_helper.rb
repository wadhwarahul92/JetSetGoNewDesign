module AircraftCategoriesHelper

  def aircraft_categories_collection
    AircraftCategory.all.collect{ |c| [c.name, c.id] }
  end

end