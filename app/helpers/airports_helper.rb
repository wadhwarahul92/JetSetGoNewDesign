module AirportsHelper

  def airports_for_collection
    Airport.all.collect{ |a| [a.name, a.id] }
  end

end