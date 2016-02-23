json.array! @activities do |activity|
  json.id activity.id
  json.title "#{activity.aircraft.tail_number}"
  json.start activity.start_at.to_s
  json.end activity.end_at.to_s
  json.className %w(trip-event hvr-wobble-horizontal)
end