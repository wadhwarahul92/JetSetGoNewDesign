json.array! @jetsteals do |jetsteal|
  json.id jetsteal.id
  json.sell_by_seats jetsteal.sell_by_seats?
  json.start_at jetsteal.start_at
  json.end_at jetsteal.end_at
  json.cost jetsteal.cost
  json.departure_airport do
    departure_airport = jetsteal.departure_airport
    json.id departure_airport.id
    json.name departure_airport.name
    json.city {
      json.id departure_airport.city.id
      json.name departure_airport.city.name
      json.state departure_airport.city.state
      json.image departure_airport.city.image.url(:original)
    }
  end
  json.arrival_airport do
    arrival_airport = jetsteal.arrival_airport
    json.id arrival_airport.id
    json.name arrival_airport.name
    json.city {
      json.id arrival_airport.city.id
      json.name arrival_airport.city.name
      json.state arrival_airport.city.state
      json.image arrival_airport.city.image.url(:original)
    }
  end
  json.aircraft do
    aircraft = jetsteal.aircraft
    json.id aircraft.id
    json.tail_number aircraft.tail_number
    json.memorable_name aircraft.memorable_name
    json.seating_capacity aircraft.seating_capacity
    json.baggage_capacity_in_kg aircraft.baggage_capacity_in_kg
    json.runway_field_length_in_feet aircraft.runway_field_length_in_feet
    json.number_of_toilets aircraft.number_of_toilets
    json.cabin_width_in_meters aircraft.cabin_width_in_meters
    json.cabin_height_in_meters aircraft.cabin_height_in_meters
    json.cabin_length_in_meters aircraft.cabin_length_in_meters
    json.aircraft_type do
      aircraft_type = aircraft.aircraft_type
      json.id aircraft_type.id
      json.name aircraft_type.name
    end
  end
end