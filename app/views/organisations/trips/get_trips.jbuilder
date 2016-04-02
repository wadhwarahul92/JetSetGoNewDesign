json.array! @trips do |trip|
  next unless trip.activities.any?
  json.id trip.id
  json.status trip.status
  json.tax Tax.tax
  json.tax_value Tax.total_tax_value
  json.user trip.user.try(:full_name)
  json.activities{
    json.array! trip.activities do |activity|
      json.id activity.id

      aircraft = activity.aircraft

      json.aircraft{
        json.id aircraft.id
        json.tail_number aircraft.tail_number
        json.name aircraft.aircraft_type.name
        json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
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

      json.start_at activity.start_at.strftime(time_format)
      json.end_at activity.end_at.strftime(time_format)
      json.empty_leg activity.empty_leg?
      json.pax (activity.pax.presence || 0)
      json.flight_cost activity.flight_cost
      json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
      json.landing_cost_at_arrival activity.landing_cost_at_arrival

      if activity.accommodation_plan.present?
        json.accommodation_plan{
          json.cost activity.accommodation_plan[:cost]
          json.nights activity.accommodation_plan[:nights]
        }
      end

      json.watch_hour_at_arrival activity.watch_hour_at_arrival?
      json.watch_hour_cost activity.watch_hour_cost

    end
  }
end