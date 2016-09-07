json.array! @activities do |activity|
  json.id activity.id
  json.title "#{activity.aircraft.tail_number}"
  json.start activity.start_at
  json.end activity.end_at
  json.className ( activity.empty_leg? ? %w(trip-event hvr-shutter-out-horizontal event-empty-leg) : %w(trip-event hvr-shutter-out-horizontal))
end