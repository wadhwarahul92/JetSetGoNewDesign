if params[:format_as] == 'event'

  json.type 'activity'
  json.id @activity.id
  json.start_at @activity.start_at.strftime(time_format)
  json.end_at @activity.end_at.strftime(time_format)
  json.empty_leg @activity.empty_leg?
  json.pax @activity.pax
  json.flight_cost @activity.flight_cost
  json.handling_cost_at_takeoff @activity.handling_cost_at_takeoff
  json.landing_cost_at_arrival @activity.landing_cost_at_arrival
  json.watch_hour_at_arrival @activity.watch_hour_at_arrival?
  json.watch_hour_cost @activity.watch_hour_cost

  if activity.accommodation_plan.present?
    json.accommodation_plan{
      json.cost activity.accommodation_plan[:cost]
      json.nights activity.accommodation_plan[:nights]
    }
  end

  json.aircraft{
    json.id @activity.aircraft.id
    json.tail_number @activity.aircraft.tail_number
    json.images @activity.aircraft.aircraft_images.map{ |m| m.image.url(:size_250x250) }
    json.aircraft_type{
      json.id @activity.aircraft.aircraft_type.id
      json.name @activity.aircraft.aircraft_type.name
    }
  }

  json.departure_airport{
    json.id @activity.departure_airport.id
    json.name @activity.departure_airport.name
    json.code @activity.departure_airport.code
    json.city{
      json.id @activity.departure_airport.city.id
      json.name @activity.departure_airport.city.name
      json.image_url @activity.departure_airport.city.image.url(:original)
    }
  }

  json.arrival_airport{
    json.id @activity.arrival_airport.id
    json.name @activity.arrival_airport.name
    json.code @activity.arrival_airport.code
    json.city{
      json.id @activity.arrival_airport.city.id
      json.name @activity.arrival_airport.city.name
      json.image_url @activity.arrival_airport.city.image.url(:original)
    }
  }

end