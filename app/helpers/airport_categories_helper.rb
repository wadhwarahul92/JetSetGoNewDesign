module AirportCategoriesHelper

  def airport_categories_for_collection
    AirportCategory.all.collect{ |a| [a.name, a.id] }
  end

end