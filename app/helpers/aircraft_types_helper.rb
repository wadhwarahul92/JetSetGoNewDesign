module AircraftTypesHelper

  def aircraft_types_for_collection
    AircraftType.all.collect{ |c| [c.name, c.id] }
  end

  def current_aircraft_types_for_collection(jetsteals)
    aircraft_types = jetsteals.map{ |j| j.aircraft.aircraft_type }.uniq
    aircraft_types.collect{ |a| [a.name, a.id] }
  end

end