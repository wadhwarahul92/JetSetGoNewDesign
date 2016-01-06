module AircraftTypesHelper

  def aircraft_types_for_collection
    AircraftType.all.collect{ |c| [c.name, c.id] }
  end

  def current_aircraft_types_for_collection(jetsteals)
    jetsteals.collect{ |c| [c.aircraft.aircraft_type.name, c.aircraft.aircraft_type.id] }.uniq
  end

end