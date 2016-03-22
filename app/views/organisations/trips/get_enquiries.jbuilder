json.array! @enquiries do |enquiry|

  json.id enquiry.id

  json.status enquiry.status

  json.user_id enquiry.user_id

  json.activities{
    json.array! enquiry.activities do |activity|

      json.id activity.id
        json.start_at activity.start_at
        json.end_at activity.end_at
        json.empty_leg activity.empty_leg
        json.pax activity.pax
        json.flight_cost activity.flight_cost
        json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
        json.landing_cost_at_arrival activity.landing_cost_at_arrival
        json.accommodation_plan activity.accommodation_plan

        json.aircraft{
          json.id activity.aircraft.id
          json.name activity.aircraft.aircraft_type.name
        }

        json.trip{
          json.id activity.trip.id
        }

        json.departure_airport{
          json.id activity.departure_airport.id
          json.name activity.departure_airport.name
          json.code activity.departure_airport.code
        }

        json.arrival_airport{
          json.id activity.arrival_airport.id
          json.name activity.arrival_airport.name
          json.code activity.arrival_airport.code
        }

    end
  }
end