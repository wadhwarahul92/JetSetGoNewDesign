json.array! @aircraft_categories.each do |aircraft_category|

  json.id aircraft_category.id
  json.name aircraft_category.name
  json.image aircraft_category.image.url(:original)

end