json.array! @empty_legs do |empty_leg|

  json.id empty_leg.id
  json.trip_id empty_leg.trip_id
  json.start_at empty_leg.start_at
  json.end_at empty_leg.end_at
  json.empty_leg empty_leg.empty_leg
  json.pax empty_leg.pax
  json.flight_cost empty_leg.flight_cost
  json.handling_cost_at_takeoff empty_leg.handling_cost_at_takeoff
  json.landing_cost_at_arrival empty_leg.landing_cost_at_arrival
  json.accommodation_plan empty_leg.accommodation_plan

  json.aircraft{
    json.id empty_leg.aircraft.id
    json.name empty_leg.aircraft.aircraft_type.name
  }

  json.trip{
    json.id empty_leg.trip.id
  }

  json.departure_airport{
    json.id empty_leg.departure_airport.id
    json.name empty_leg.departure_airport.name
  }

  json.arrival_airport{
    json.id empty_leg.arrival_airport.id
    json.name empty_leg.arrival_airport.name
  }

end