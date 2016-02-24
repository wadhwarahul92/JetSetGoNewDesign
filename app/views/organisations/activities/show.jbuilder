if params[:format_as] == 'event'
  json.type 'activity'
  json.id @activity.id
  json.start_at @activity.start_at.strftime(time_format)
  json.end_at @activity.end_at.strftime(time_format)
  json.departure_airport{
    json.id @activity.departure_airport.id
    json.name @activity.departure_airport.name
    json.city{
      json.id @activity.departure_airport.city.id
      json.name @activity.departure_airport.city.name
      json.image_url @activity.departure_airport.city.image.url(:original)
    }
  }
  json.arrival_airport{
    json.id @activity.arrival_airport.id
    json.name @activity.arrival_airport.name
    json.city{
      json.id @activity.arrival_airport.city.id
      json.name @activity.arrival_airport.city.name
      json.image_url @activity.arrival_airport.city.image.url(:original)
    }
  }
  json.pax @activity.pax
  json.empty_leg @activity.empty_leg?
  json.aircraft{
    json.id @activity.aircraft.id
    json.tail_number @activity.aircraft.tail_number
    json.images @activity.aircraft.aircraft_images.map{ |m| m.image.url(:size_250x250) }
    json.aircraft_type{
      json.id @activity.aircraft.aircraft_type.id
      json.name @activity.aircraft.aircraft_type.name
    }
  }
end