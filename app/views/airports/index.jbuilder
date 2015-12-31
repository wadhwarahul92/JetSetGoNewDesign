# //dont edit it, used in mobile app
json.array! @airports do |airport|
  json.id airport.id
  json.name airport.name
  json.city {
    json.id airport.city.id
    json.name airport.city.name
    json.state airport.city.state
    if airport.city and airport.city.image.present?
      json.image airport.city.image.url(:original)
    end
  }
end