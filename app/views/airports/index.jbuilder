# //dont edit it, used in mobile app
json.array! @airports do |airport|
  json.id airport.id
  json.name airport.name
  json.icao_code airport.icao_code
  json.code airport.code
  json.longitude airport.longitude
  json.latitude airport.latitude
  json.night_landing airport.night_landing
  json.night_parking airport.night_parking
  json.private_landing airport.private_landing
  json.label "#{airport.name}, #{airport.city.name}"
  json.city {
    json.id airport.city.id
    json.name airport.city.name
    json.state airport.city.state
    if airport.city and airport.city.image.present?
      json.image airport.city.image.url(:original)
    end
  }
end