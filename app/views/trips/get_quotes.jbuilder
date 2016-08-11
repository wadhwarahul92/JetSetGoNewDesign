json.array! @quotes do |quote|

  json.tax Tax.tax
  json.tax_value Tax.total_tax_value
  json.id quote.id
  json.status quote.status
  json.jsg_commission Admin::JSG_COMMISSION_IN_PERCENTAGE
  json.activities{
    json.array! quote.activities do |activity|
      json.id activity.id

      aircraft = activity.aircraft

      json.aircraft{
        json.id aircraft.id
        json.tail_number aircraft.tail_number
        json.aircraft_flight_cost_commission_in_percentage aircraft.flight_cost_commission_in_percentage
        json.aircraft_handling_cost_commission_in_percentage aircraft.handling_cost_commission_in_percentage
        json.aircraft_accomodation_cost_commission_in_percentage aircraft.accomodation_cost_commission_in_percentage
        json.exterior_image aircraft.image.url(:original)
        json.interior_image aircraft.interior.url(:original)
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
      }

      json.arrival_airport{
        json.id activity.arrival_airport.id
        json.name activity.arrival_airport.name
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