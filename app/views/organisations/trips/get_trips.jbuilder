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

      json.base_airport{
        json.id aircraft.base_airport.id
        json.name aircraft.base_airport.name
        json.longitude aircraft.base_airport.longitude
        json.latitude aircraft.base_airport.latitude
        json.code aircraft.base_airport.code
        json.private_landing aircraft.base_airport.private_landing?
        json.night_parking aircraft.base_airport.night_parking?
        json.ifr_or_vfr aircraft.base_airport.ifr_or_vfr
        json.fuel_availability aircraft.base_airport.fuel_availability
        json.watch_hour_extension aircraft.base_airport.watch_hour_extension
        json.icao_code aircraft.base_airport.icao_code
        json.runway_field_length_in_feet aircraft.base_airport.runway_field_length_in_feet
        json.landing_cost aircraft.base_airport.landing_cost
        json.city{
          json.id aircraft.base_airport.city.id
          json.name aircraft.base_airport.city.name
          json.image_url aircraft.base_airport.city.image.url(:original)
        }
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