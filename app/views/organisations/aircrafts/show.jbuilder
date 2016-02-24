json.id @aircraft.id
json.tail_number @aircraft.tail_number
json.seating_capacity @aircraft.seating_capacity
json.per_hour_cost @aircraft.per_hour_cost
json.catering_cost_per_pax @aircraft.catering_cost_per_pax
json.aircraft_type{
  json.id @aircraft.aircraft_type.id
  json.name @aircraft.aircraft_type.name
}
json.aircraft_images{
  json.array! @aircraft.aircraft_images.map(&:image).map{ |m| m.url(:size_250x250) }
}