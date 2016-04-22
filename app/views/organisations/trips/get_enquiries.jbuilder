json.array! @enquiries do |enquiry|

  next unless enquiry.activities.any?

  json.id enquiry.id
  json.status enquiry.status
  json.tax Tax.tax
  json.tax_value Tax.total_tax_value
  json.user enquiry.user.try(:full_name)

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
        json.tail_number activity.aircraft.tail_number
        json.images activity.aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
      }

      json.trip{
        json.id activity.trip.id
      }

      json.base_airport{
        json.id activity.aircraft.base_airport.id
        json.name activity.aircraft.base_airport.name
        json.longitude activity.aircraft.base_airport.longitude
        json.latitude activity.aircraft.base_airport.latitude
        json.code activity.aircraft.base_airport.code
        json.private_landing activity.aircraft.base_airport.private_landing?
        json.night_parking activity.aircraft.base_airport.night_parking?
        json.ifr_or_vfr activity.aircraft.base_airport.ifr_or_vfr
        json.fuel_availability activity.aircraft.base_airport.fuel_availability
        json.watch_hour_extension activity.aircraft.base_airport.watch_hour_extension
        json.icao_code activity.aircraft.base_airport.icao_code
        json.runway_field_length_in_feet activity.aircraft.base_airport.runway_field_length_in_feet
        json.landing_cost activity.aircraft.base_airport.landing_cost
        json.city{
          json.id activity.aircraft.base_airport.city.id
          json.name activity.aircraft.base_airport.city.name
          json.image_url activity.aircraft.base_airport.city.image.url(:original)
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

    end
  }
end