json.array! @aircraft_unavailabilities do |aircraft_unavailability|
  json.id aircraft_unavailability.id
  json.title "#{aircraft_unavailability.aircraft.tail_number} - #{aircraft_unavailability.reason}"
  json.start aircraft_unavailability.start_at.strftime(time_format)
  json.end aircraft_unavailability.end_at.strftime(time_format)
  json.className ['aircraft_unavailability_event']
  json.image aircraft_unavailability.aircraft.aircraft_images.first.image.url(:size_250x250)
end