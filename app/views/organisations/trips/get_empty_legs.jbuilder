json.array! @empty_legs do |empty_leg|

  next unless empty_leg.activities.any?

  json.id empty_leg.id

  json.status empty_leg.status

  json.user_id empty_leg.user_id

  json.aircraft_image_url empty_leg.activities.first.aircraft.aircraft_images.first.image.url(:size_250x250)

  json.activities{
    json.array! empty_leg.activities do |activity|
      json.id activity.id
      json.start_at activity.start_at
      json.end_at activity.end_at
      json.pax activity.pax
      json.flight_cost activity.flight_cost
      json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
      json.landing_cost_at_arrival activity.landing_cost_at_arrival
      json.watch_hour_at_arrival activity.watch_hour_at_arrival?
      json.watch_hour_cost activity.watch_hour_cost

      if activity.accommodation_plan.present?
        json.accommodation_plan{
          json.cost activity.accommodation_plan[:cost]
          json.nights activity.accommodation_plan[:nights]
        }
      end

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