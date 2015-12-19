module AircraftTypesHelper

  def aircraft_types_for_collection
    AircraftType.all.collect{ |c| [c.name, c.id] }
  end

end