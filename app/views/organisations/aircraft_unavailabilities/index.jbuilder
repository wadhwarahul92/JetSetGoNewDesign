json.array! @aircraft_unavailabilities do |aircraft_unavailability|
  json.id aircraft_unavailability.id
  json.title aircraft_unavailability.aircraft.tail_number
  json.start aircraft_unavailability.start_at.to_s
  json.end aircraft_unavailability.end_at.to_s
  json.className ['aircraft_unavailability_event']
end