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
else
  json.id @aircraft_unavailability.id
  json.start_at @aircraft_unavailability.start_at.to_s
  json.end_at @aircraft_unavailability.end_at.to_s
  json.reason @aircraft_unavailability.reason
end