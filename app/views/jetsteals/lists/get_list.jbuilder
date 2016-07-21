json.array! @jetsteals do |jetsteal|
  json.id jetsteal.id
  json.sell_by_seats jetsteal.sell_by_seats?
  json.start_at jetsteal.start_at.strftime('%d %b %Y, %I:%M %p')
  json.end_at jetsteal.end_at.strftime('%d %b %Y, %I:%M %p')
  json.flight_start_time jetsteal.end_at.strftime('%d %b %Y, %I:%M %p')
  json.flight_end_time (jetsteal.end_at + jetsteal.flight_duration_in_minutes.minutes).strftime('%d %b %Y, %I:%M %p')
  json.date jetsteal.end_at.strftime('%d %b %Y')
  json.min_seat_cost jetsteal.min_seat_cost || 0
  json.cost jetsteal.cost
  json.flight_duration_in_minutes jetsteal.flight_duration_in_minutes
  json.sold_out jetsteal.sold_out.present?
  json.can_be_sold_as_whole jetsteal.can_be_sold_as_whole?
  json.departure_airport do
    departure_airport = jetsteal.departure_airport
    json.id departure_airport.id
    json.name departure_airport.name
    json.longitude departure_airport.longitude
    json.latitude departure_airport.latitude
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
    json.longitude arrival_airport.longitude
    json.latitude arrival_airport.latitude
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
    json.landing_field_length_in_feet aircraft.landing_field_length_in_feet
    json.runway_field_length_in_feet aircraft.runway_field_length_in_feet
    json.number_of_toilets aircraft.number_of_toilets
    json.cabin_width_in_meters aircraft.cabin_width_in_meters
    json.cabin_height_in_meters aircraft.cabin_height_in_meters
    json.cabin_length_in_meters aircraft.cabin_length_in_meters
    json.image aircraft.image.url(:original)
    json.aircraft_images aircraft.aircraft_images.map{ |aircraft_image| aircraft_image.image.url(:size_250x250) }
    json.original_aircraft_images aircraft.aircraft_images.map{ |aircraft_image| aircraft_image.image.url(:original) }
    json.crew aircraft.crew
    json.wifi aircraft.wifi?
    json.phone aircraft.phone?
    json.flight_attendant aircraft.flight_attendant?
    json.aircraft_type do
      aircraft_type = aircraft.aircraft_type
      json.id aircraft_type.id
      json.name aircraft_type.name
      json.speed_in_kts aircraft_type.speed_in_kts
      json.description aircraft_type.description
      json.aircraft_category{
        json.id aircraft_type.aircraft_category.id
        json.name aircraft_type.aircraft_category.name
      }
    end
  end
  json.jetsteal_seats{
    json.array!(jetsteal.jetsteal_seats) do |jetsteal_seat|
      json.id jetsteal_seat.id
      json.ui_seat_id jetsteal_seat.ui_seat_id
      json.disabled jetsteal_seat.disabled?
      json.cost jetsteal_seat.cost
      json.booked jetsteal_seat.booked?
      json.orientation jetsteal_seat.orientation
      json.seat_type jetsteal_seat.seat_type
    end
  }
end