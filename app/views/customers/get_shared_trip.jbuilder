json.id @trip.id
json.status @trip.status
json.catering @trip.catering
json.sell_empty_leg @trip.sell_empty_leg
json.user @trip.user.try(:full_name)
# json.user_email @trip.user.try(:email)

json.activities{
  json.array! @trip.activities do |activity|
    json.id activity.id

    aircraft = activity.aircraft

    json.aircraft{
      json.id aircraft.id
      json.tail_number aircraft.tail_number
      json.per_hour_cost aircraft.per_hour_cost
      json.exterior_image aircraft.image.url(:original)
      json.interior_image aircraft.interior.url(:original)
      json.crew aircraft.crew
      json.wifi aircraft.wifi
      json.phone aircraft.phone
      json.cabin_height_in_meters aircraft.cabin_height_in_meters
      json.number_of_toilets aircraft.number_of_toilets
      json.flight_attendant aircraft.flight_attendant
      json.baggage_capacity_in_kg aircraft.baggage_capacity_in_kg
      json.seating_capacity aircraft.seating_capacity
      json.cruise_speed_in_nm_per_hour aircraft.cruise_speed_in_nm_per_hour
      json.aircraft_flight_cost_commission_in_percentage aircraft.flight_cost_commission_in_percentage
      json.aircraft_handling_cost_commission_in_percentage aircraft.handling_cost_commission_in_percentage
      json.aircraft_accomodation_cost_commission_in_percentage aircraft.accomodation_cost_commission_in_percentage
      json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }

      json.aircraft_type{
        json.id aircraft.aircraft_type.id
        json.name aircraft.aircraft_type.name
        json.aircraft_category_name aircraft.aircraft_type.aircraft_category.name
        json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
      }

    }

    json.departure_airport{
      json.id activity.departure_airport.id
      json.name activity.departure_airport.name
      json.code activity.departure_airport.code
      json.icao_code activity.departure_airport.icao_code

      json.city{
        json.name activity.departure_airport.city.name
        json.state activity.departure_airport.city.state
      }
    }

    json.arrival_airport{
      json.id activity.arrival_airport.id
      json.name activity.arrival_airport.name
      json.code activity.arrival_airport.code
      json.icao_code activity.arrival_airport.icao_code
      json.city{
        json.name activity.arrival_airport.city.name
        json.state activity.arrival_airport.city.state
      }
    }

    json.start_at activity.start_at.strftime(time_format)
    json.end_at activity.end_at.strftime(time_format)
    json.empty_leg activity.empty_leg?
    json.pax (activity.pax.presence || 0)
    json.flight_cost activity.flight_cost
    json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
    json.landing_cost_at_arrival activity.landing_cost_at_arrival

    if activity.accommodation_plan.present?
      json.accommodation_plan{
        json.cost activity.accommodation_plan[:cost]
        json.nights activity.accommodation_plan[:nights]
      }
    end

    json.watch_hour_at_arrival activity.watch_hour_at_arrival?
    json.watch_hour_cost activity.watch_hour_cost

  end
}

json.passengers{
  json.array! @trip.passenger_details do |passenger|
    json.title passenger.title
    json.name passenger.name
    json.nationality passenger.nationality
  end
}