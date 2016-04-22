json.id @aircraft.id
json.tail_number @aircraft.tail_number
json.seating_capacity @aircraft.seating_capacity
json.per_hour_cost @aircraft.per_hour_cost
# json.catering_cost_per_pax @aircraft.catering_cost_per_pax
json.aircraft_type{
  json.id @aircraft.aircraft_type.id
  json.name @aircraft.aircraft_type.name
}
json.aircraft_images{
  json.array! @aircraft.aircraft_images.map(&:image).map{ |m| m.url(:size_250x250) }
}
json.base_airport{
  json.id @aircraft.base_airport.id
  json.name @aircraft.base_airport.name
  json.longitude @aircraft.base_airport.longitude
  json.latitude @aircraft.base_airport.latitude
  json.code @aircraft.base_airport.code
  json.private_landing @aircraft.base_airport.private_landing?
  json.night_parking @aircraft.base_airport.night_parking?
  json.ifr_or_vfr @aircraft.base_airport.ifr_or_vfr
  json.fuel_availability @aircraft.base_airport.fuel_availability
  json.watch_hour_extension @aircraft.base_airport.watch_hour_extension
  json.icao_code @aircraft.base_airport.icao_code
  json.runway_field_length_in_feet @aircraft.base_airport.runway_field_length_in_feet
  json.landing_cost @aircraft.base_airport.landing_cost
  json.city{
    json.id @aircraft.base_airport.city.id
    json.name @aircraft.base_airport.city.name
    json.image_url @aircraft.base_airport.city.image.url(:original)
  }
}