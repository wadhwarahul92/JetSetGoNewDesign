events = []
@activities.each do |activity|
  events << {
      id: "activity-#{activity.id}",
      start: activity.start_at.to_s,
      end: activity.end_at.to_s,
      title: ( activity.empty_leg? ? "#{activity.aircraft.tail_number} - Empty Leg" : "#{activity.aircraft.tail_number} - Trip"),
      className: ( activity.empty_leg? ? %w(trip-event hvr-shutter-out-horizontal event-empty-leg) : %w(trip-event hvr-shutter-out-horizontal)),
      popover: "#{activity.start_at.strftime(time_format)} TO #{activity.end_at.strftime(time_format)}",
      popover_title: (activity.empty_leg? ? 'Empty Leg' : 'Trip')
  }
end
@aircraft_unavailabilities.each do |aircraft_unavailability|
  events << {
      id: "aircraft_unavailability-#{aircraft_unavailability.id}",
      start: aircraft_unavailability.start_at.to_s,
      end: aircraft_unavailability.end_at.to_s,
      title: "#{aircraft_unavailability.aircraft.tail_number} - Unavailable - #{aircraft_unavailability.reason}",
      className: %w(trip-event hvr-shutter-out-horizontal event-unavailability),
      popover: "#{aircraft_unavailability.start_at.strftime(time_format)} TO #{aircraft_unavailability.end_at.strftime(time_format)}",
      popover_title: 'Aircraft Unavailability'
  }
end
json.array! events