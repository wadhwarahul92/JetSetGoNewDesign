json.id @activity.id
json.start_at @activity.start_at.strftime(time_format)
json.end_at @activity.end_at.strftime(time_format)
json.departure_airport{
  json.name @activity.departure_airport.name
  json.city{
    json.name @activity.departure_airport.city.name
    json.url @activity.departure_airport.city.image.url(:original)
  }
}
json.arrival_airport{
  json.name @activity.arrival_airport.name
  json.city{
    json.name @activity.arrival_airport.city.name
    json.url @activity.arrival_airport.city.image.url(:original)
  }
}
json.empty_leg @activity.empty_leg?
json.pax @activity.pax
json.aircraft{
  json.id @activity.aircraft.id
  json.tail_number @activity.aircraft.tail_number
  json.images @activity.aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
}