module AirportsHelper

  def airports_for_collection
    Airport.includes(:city).all.collect{ |a| ["#{a.city.name} - #{a.name}", a.id] }
  end

end