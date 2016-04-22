if params[:format_as] == 'event'
  json.id @aircraft_unavailability.id
  json.type 'aircraft_unavailability'
  json.start_at @aircraft_unavailability.start_at.strftime(time_format)
  json.end_at @aircraft_unavailability.end_at.strftime(time_format)
  json.reason @aircraft_unavailability.reason
  json.aircraft{
    json.id @aircraft_unavailability.aircraft.id
    json.tail_number @aircraft_unavailability.aircraft.tail_number
    json.images @aircraft_unavailability.aircraft.aircraft_images.map{ |m| m.image.url(:size_250x250) }
    json.aircraft_type{
      json.id @aircraft_unavailability.aircraft.aircraft_type.id
      json.name @aircraft_unavailability.aircraft.aircraft_type.name
    }
  }
  json.base_airport{
    json.id @aircraft_unavailability.aircraft.base_airport.id
    json.name @aircraft_unavailability.aircraft.base_airport.name
    json.longitude @aircraft_unavailability.aircraft.base_airport.longitude
    json.latitude @aircraft_unavailability.aircraft.base_airport.latitude
    json.code @aircraft_unavailability.aircraft.base_airport.code
    json.private_landing @aircraft_unavailability.aircraft.base_airport.private_landing?
    json.night_parking @aircraft_unavailability.aircraft.base_airport.night_parking?
    json.ifr_or_vfr @aircraft_unavailability.aircraft.base_airport.ifr_or_vfr
    json.fuel_availability @aircraft_unavailability.aircraft.base_airport.fuel_availability
    json.watch_hour_extension @aircraft_unavailability.aircraft.base_airport.watch_hour_extension
    json.icao_code @aircraft_unavailability.aircraft.base_airport.icao_code
    json.runway_field_length_in_feet @aircraft_unavailability.aircraft.base_airport.runway_field_length_in_feet
    json.landing_cost @aircraft_unavailability.aircraft.base_airport.landing_cost
    json.city{
      json.id @aircraft_unavailability.aircraft.base_airport.city.id
      json.name @aircraft_unavailability.aircraft.base_airport.city.name
      json.image_url @aircraft_unavailability.aircraft.base_airport.city.image.url(:original)
    }
  }
else
  json.id @aircraft_unavailability.id
  json.start_at @aircraft_unavailability.start_at.to_s
  json.end_at @aircraft_unavailability.end_at.to_s
  json.reason @aircraft_unavailability.reason
end
