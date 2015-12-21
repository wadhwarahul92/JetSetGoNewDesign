module AircraftsHelper

  def aircrafts_for_collection
    Aircraft.all.collect{ |a| [a.tail_number, a.id] }
  end

end