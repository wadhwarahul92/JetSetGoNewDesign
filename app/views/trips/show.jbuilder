json.id @trip.id
json.status @trip.status
json.catering @trip.catering
json.sell_empty_leg @trip.sell_empty_leg
json.user @trip.user.try(:full_name)

json.payment_transaction{
  next unless @trip.payment_transaction.present?
  json.id @trip.payment_transaction.first.id
  json.status @trip.payment_transaction.first.status
  json.processor_response eval(@trip.payment_transaction.first.processor_response)
  json.amount @trip.payment_transaction.first.amount
  json.billing_address @trip.payment_transaction.first.billing_address
  json.billing_city @trip.payment_transaction.first.billing_city
  json.billing_state @trip.payment_transaction.first.billing_state
  json.billing_zip @trip.payment_transaction.first.billing_zip
  json.billing_country @trip.payment_transaction.first.billing_country
}

json.activities{
  json.array! @trip.activities do |activity|
    json.id activity.id

    aircraft = activity.aircraft

    json.aircraft{
      json.id aircraft.id
      json.tail_number aircraft.tail_number
      json.per_hour_cost aircraft.per_hour_cost
      json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }

      json.aircraft_type{
        json.id aircraft.aircraft_type.id
        json.name aircraft.aircraft_type.name
        json.aircraft_category_name aircraft.aircraft_type.aircraft_category.name
        json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
      }

    }

    json.departure_airport{
      json.id activity.departure_airport.id
      json.name activity.departure_airport.name
      json.code activity.departure_airport.code
      json.icao_code activity.departure_airport.icao_code

      json.city{
        json.name activity.departure_airport.city.name
        json.state activity.departure_airport.city.state
      }
    }

    json.arrival_airport{
      json.id activity.arrival_airport.id
      json.name activity.arrival_airport.name
      json.code activity.arrival_airport.code
      json.icao_code activity.arrival_airport.icao_code
      json.city{
        json.name activity.arrival_airport.city.name
        json.state activity.arrival_airport.city.state
      }
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