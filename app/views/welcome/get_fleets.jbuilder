json.array! @aircrafts do |aircraft|

  json.id aircraft.id
  json.tail_number aircraft.tail_number
  json.one_liner aircraft.one_liner
  json.description aircraft.description
  json.seating_capacity aircraft.seating_capacity
  json.baggage_capacity_in_kg aircraft.baggage_capacity_in_kg
  json.runway_field_length_in_feet aircraft.runway_field_length_in_feet
  json.number_of_toilets aircraft.number_of_toilets
  json.cabin_width_in_meters aircraft.cabin_width_in_meters
  json.cabin_height_in_meters aircraft.cabin_height_in_meters
  json.cabin_length_in_meters aircraft.cabin_length_in_meters
  json.crew aircraft.crew
  json.wifi aircraft.wifi
  json.phone aircraft.phone
  json.flight_attendant aircraft.flight_attendant
  json.year_of_manufacture aircraft.year_of_manufacture
  json.medical_evac aircraft.medical_evac
  json.cruise_speed_in_nm_per_hour aircraft.cruise_speed_in_nm_per_hour
  json.flying_range_in_nm aircraft.flying_range_in_nm
  json.per_hour_cost aircraft.per_hour_cost

  json.exterior_image aircraft.image.url(:original)
  json.interior_image aircraft.interior.url(:original)
  json.specification_image aircraft.specification_image.url(:original)
  json.range_map_image aircraft.range_map_image.url(:original)

  # json.catering_cost_per_pax aircraft.catering_cost_per_pax
  json.aircraft_type{
    json.id aircraft.aircraft_type.id
    json.name aircraft.aircraft_type.name
  }
  json.aircraft_images{
    json.array! aircraft.aircraft_images do |aircraft_image|
      json.id aircraft_image.id
      json.url aircraft_image.image.url(:size_250x250)
    end
  }
  json.base_airport{
    if aircraft.base_airport.present?
      json.id aircraft.base_airport.id
      json.name aircraft.base_airport.name
    end
  }

end