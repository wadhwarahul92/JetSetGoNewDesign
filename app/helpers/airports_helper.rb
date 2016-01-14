module AirportsHelper

  def airports_for_collection
    Airport.includes(:city).all.collect{ |a| ["#{a.city.name} - #{a.name}", a.id] }
  end

  def airports_for_collection_from_jetsteals(jetsteals, type)
    case type
      when 'departure'
        jetsteals.map(&:departure_airport).uniq.collect{ |a| ["#{a.city.name} - #{a.name}", a.id] }
      when 'arrival'
        jetsteals.map(&:arrival_airport).uniq.collect{ |a| ["#{a.city.name} - #{a.name}", a.id] }
      else
        raise 'Type is required here, dumb-ass'
    end
  end

end