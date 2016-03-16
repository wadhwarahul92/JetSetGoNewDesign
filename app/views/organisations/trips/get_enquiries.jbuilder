json.array! @enquiries do |enquiry|

  json.id enquiry.id
  json.trip_id enquiry.trip_id
  json.start_at enquiry.start_at
  json.end_at enquiry.end_at
  json.empty_leg enquiry.empty_leg
  json.pax enquiry.pax
  json.flight_cost enquiry.flight_cost
  json.handling_cost_at_takeoff enquiry.handling_cost_at_takeoff
  json.landing_cost_at_arrival enquiry.landing_cost_at_arrival
  json.accommodation_plan enquiry.accommodation_plan

  json.aircraft{
    json.id enquiry.aircraft.id
    json.name enquiry.aircraft.aircraft_type.name
  }

  json.trip{
    json.id enquiry.trip.id
  }

  json.departure_airport{
    json.id enquiry.departure_airport.id
    json.name enquiry.departure_airport.name
  }

  json.arrival_airport{
    json.id enquiry.arrival_airport.id
    json.name enquiry.arrival_airport.name
  }

end