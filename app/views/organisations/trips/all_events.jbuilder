events = []
# noinspection RailsChecklist02
@activities.each do |activity|
  events << {
      id: "activity-#{activity.id}",
      trip_id: activity.trip.id,
      start: activity.start_at.to_s,
      start_for_web: activity.start_at,
      end_for_web: activity.end_at,
      end: activity.end_at.to_s,
      title: ( activity.empty_leg? ? "#{activity.aircraft.tail_number} - Empty Leg" : "#{activity.aircraft.tail_number} - Trip"),
      className: ( activity.empty_leg? ? %w(trip-event hvr-shutter-out-horizontal event-empty-leg) : %w(trip-event hvr-shutter-out-horizontal)),
      popover: "#{activity.start_at.strftime(time_format)} --TO-- #{activity.end_at.strftime(time_format)}",
      popover_title: (activity.empty_leg? ? 'Empty Leg' : 'Trip'),
      status: activity.trip.status,
      empty_leg: activity.empty_leg?
  }
end
# noinspection RailsChecklist02
@aircraft_unavailabilities.each do |aircraft_unavailability|
  events << {
      id: "aircraft_unavailability-#{aircraft_unavailability.id}",
      start: aircraft_unavailability.start_at.to_s,
      end: aircraft_unavailability.end_at.to_s,
      start_for_web: aircraft_unavailability.start_at,
      end_for_web: aircraft_unavailability.end_at,
      title: "#{aircraft_unavailability.aircraft.tail_number} - Unavailable - #{aircraft_unavailability.reason}",
      className: %w(trip-event hvr-shutter-out-horizontal event-unavailability),
      popover: "#{aircraft_unavailability.start_at.strftime(time_format)} --TO-- #{aircraft_unavailability.end_at.strftime(time_format)}",
      popover_title: 'Aircraft Unavailability'
  }
end
# noinspection RailsChecklist02
@enquiries.each do |enquiry|
  next unless enquiry.activities.any?
  events << {
      id: "enquiry-#{enquiry.id}",
      trip_id: enquiry.id,
      start: enquiry.activities.first.start_at.to_s,
      end: enquiry.activities.last.end_at.to_s,
      start_for_web: enquiry.activities.first.start_at,
      end_for_web: enquiry.activities.last.end_at,
      title: "#{enquiry.activities.first.aircraft.tail_number} - Enquiry",
      className: %w{trip-calendar trip-enquiry hvr-shutter-out-horizontal},
      popover: "#{enquiry.activities.first.start_at.strftime(time_format)} --TO-- #{enquiry.activities.last.end_at.strftime(time_format)}",
      popover_title: 'Enquiry',
      status: Trip::STATUS_ENQUIRY
  }
end
# noinspection RailsChecklist02
@quotes.each do |quote|
  next unless quote.activities.any?
  events << {
      id: "quote-#{quote.id}",
      trip_id: quote.id,
      start: quote.activities.first.start_at.to_s,
      end: quote.activities.last.end_at.to_s,
      start_for_web: quote.activities.first.start_at,
      end_for_web: quote.activities.last.end_at,
      title: "#{quote.activities.first.aircraft.tail_number} - Quote",
      className: %w{trip-calendar trip-quote hvr-shutter-out-horizontal},
      popover: "#{quote.activities.first.start_at.strftime(time_format)} --TO-- #{quote.activities.last.end_at.strftime(time_format)}",
      popover_title: 'Quote',
      status: Trip::STATUS_QUOTED
  }
end
json.array! events