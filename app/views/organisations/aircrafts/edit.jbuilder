json.id @aircraft.id
json.tail_number @aircraft.tail_number
json.seating_capacity @aircraft.seating_capacity
json.baggage_capacity_in_kg @aircraft.baggage_capacity_in_kg
json.runway_field_length_in_feet @aircraft.runway_field_length_in_feet
json.landing_field_length_in_feet @aircraft.landing_field_length_in_feet
json.number_of_toilets @aircraft.number_of_toilets
json.cabin_width_in_meters @aircraft.cabin_width_in_meters
json.cabin_height_in_meters @aircraft.cabin_height_in_meters
json.crew @aircraft.crew
json.wifi @aircraft.wifi
json.phone @aircraft.phone
json.flight_attendant @aircraft.flight_attendant
json.year_of_manufacture @aircraft.year_of_manufacture
json.medical_evac @aircraft.medical_evac
json.cruise_speed_in_nm_per_hour @aircraft.cruise_speed_in_nm_per_hour
json.flying_range_in_nm @aircraft.flying_range_in_nm
json.per_hour_cost @aircraft.per_hour_cost
json.mtow @aircraft.mtow
# json.catering_cost_per_pax @aircraft.catering_cost_per_pax
json.aircraft_type_id @aircraft.aircraft_type_id
json.aircraft_type{
  json.id @aircraft.aircraft_type.id
  json.name @aircraft.aircraft_type.name
}
json.base_airport{
  json.id @aircraft.base_airport.id
  json.name @aircraft.base_airport.name
  json.longitude @aircraft.base_airport.longitude
  json.latitude @aircraft.base_airport.latitude
  json.code @aircraft.base_airport.code
  json.icao_code @aircraft.base_airport.icao_code
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
