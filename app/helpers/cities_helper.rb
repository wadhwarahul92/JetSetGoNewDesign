module CitiesHelper

  def cities_for_collection
    City.all.collect{ |c| [c.name, c.id] }
  end

end