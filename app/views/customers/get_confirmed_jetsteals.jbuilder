json.jetsteals{
  json.array! @jetsteals[:jetsteals] do |jetsteal|

    json.id jetsteal.id
    json.aircraft_id jetsteal.aircraft_id
    json.sell_by_seats jetsteal.sell_by_seats?
    json.start_at jetsteal.start_at
    json.end_at jetsteal.end_at
    json.cost jetsteal.cost
    json.processor_response eval(jetsteal.payment_transaction.processor_response) if jetsteal.payment_transaction.processor_response.present?
    json.amount_for_seats jetsteal.payment_transaction.amount
    json.launched jetsteal.launched?
    json.flight_duration_in_minutes jetsteal.flight_duration_in_minutes
    json.email_sent jetsteal.email_sent?


    json.departure_airport{
      json.id jetsteal.departure_airport.id
      json.name jetsteal.departure_airport.name
    }

    json.arrival_airport{
      json.id jetsteal.arrival_airport.id
      json.name jetsteal.arrival_airport.name
    }

    json.aircraft{
      json.id jetsteal.aircraft.id
      json.tail_number jetsteal.aircraft.tail_number
      json.seating_capacity jetsteal.aircraft.seating_capacity
      json.baggage_capacity_in_kg jetsteal.aircraft.baggage_capacity_in_kg
      json.runway_field_length_in_feet jetsteal.aircraft.runway_field_length_in_feet
      json.number_of_toilets jetsteal.aircraft.number_of_toilets
      json.cabin_width_in_meters jetsteal.aircraft.cabin_width_in_meters
      json.cabin_height_in_meters jetsteal.aircraft.cabin_height_in_meters
      json.crew jetsteal.aircraft.crew
      json.wifi jetsteal.aircraft.wifi
      json.phone jetsteal.aircraft.phone
      json.flight_attendant jetsteal.aircraft.flight_attendant
      json.year_of_manufacture jetsteal.aircraft.year_of_manufacture
      json.medical_evac jetsteal.aircraft.medical_evac
      json.cruise_speed_in_nm_per_hour jetsteal.aircraft.cruise_speed_in_nm_per_hour
      json.flying_range_in_nm jetsteal.aircraft.flying_range_in_nm
      json.per_hour_cost jetsteal.aircraft.per_hour_cost

      json.flight_cost_commission_in_percentage jetsteal.aircraft.flight_cost_commission_in_percentage
      json.handling_cost_commission_in_percentage jetsteal.aircraft.handling_cost_commission_in_percentage
      json.accomodation_cost_commission_in_percentage jetsteal.aircraft.accomodation_cost_commission_in_percentage

      json.image jetsteal.aircraft.image.url(:original)
      json.interior_image_original jetsteal.aircraft.interior.url(:original)
      json.interior_image_size_400 jetsteal.aircraft.interior.url(:size_400x400)
      # json.catering_cost_per_pax aircraft.catering_cost_per_pax
      json.aircraft_type{
        json.id jetsteal.aircraft.aircraft_type.id
        json.name jetsteal.aircraft.aircraft_type.name
      }

      json.aircraft_category{
        if jetsteal.aircraft.aircraft_type.aircraft_category.present?
          json.id jetsteal.aircraft.aircraft_type.aircraft_category.id
          json.name jetsteal.aircraft.aircraft_type.aircraft_category.name
        end
      }

      json.aircraft_images{
        json.array! jetsteal.aircraft.aircraft_images do |aircraft_image|
          json.id aircraft_image.id
          json.url aircraft_image.image.url(:size_250x250)
        end
      }
      json.base_airport{
        if jetsteal.aircraft.base_airport.present?
          json.id jetsteal.aircraft.base_airport.id
          json.name jetsteal.aircraft.base_airport.name
        end
      }

    }



  end
}

json.trips{
  json.array! @jetsteals[:trips] do |trip|

    json.id trip.id
    json.status trip.status
    json.payment_status trip.payment_status
    json.amount_paid trip.amount_paid
    json.sell_empty_leg trip.sell_empty_leg

    json.activities{
      json.array! trip.activities do |activity|
        json.id activity.id
        json.grandTotal activity.grand_total

        aircraft = activity.aircraft

        json.aircraft{
          json.id aircraft.id
          json.tail_number aircraft.tail_number
          json.name aircraft.aircraft_type.name
          json.aircraft_flight_cost_commission_in_percentage aircraft.flight_cost_commission_in_percentage
          json.aircraft_handling_cost_commission_in_percentage aircraft.handling_cost_commission_in_percentage
          json.aircraft_accomodation_cost_commission_in_percentage aircraft.accomodation_cost_commission_in_percentage
          json.exterior_image aircraft.image.url(:original)
          json.interior_image aircraft.interior.url(:original)
          json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
        }

        json.base_airport{
          json.id aircraft.base_airport.id
          json.name aircraft.base_airport.name
          json.longitude aircraft.base_airport.longitude
          json.latitude aircraft.base_airport.latitude
          json.code aircraft.base_airport.code
          json.icao_code aircraft.base_airport.icao_code
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
          json.icao_code activity.departure_airport.icao_code
        }

        json.arrival_airport{
          json.id activity.arrival_airport.id
          json.name activity.arrival_airport.name
          json.code activity.arrival_airport.code
          json.icao_code activity.arrival_airport.icao_code
        }

        json.start_at activity.start_at.strftime(time_format)
        json.end_at activity.end_at.strftime(time_format)
        json.empty_leg activity.empty_leg?
        json.pax (activity.pax.presence || 0)
        json.flight_cost activity.flight_cost
        json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
        json.landing_cost_at_arrival activity.landing_cost_at_arrival
        json.empty_leg_whole_price activity.empty_leg_whole_price
        json.empty_leg_seat_price activity.empty_leg_seat_price

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

    json.user{
      json.id trip.user.id
      json.first_name trip.user.first_name
      json.email trip.user.email
      json.phone trip.user.phone
      json.address trip.user.address

      json.image trip.user.image.url(:size_250x250) if trip.user.image.present?
    }

    json.aircraft{
      aircraft = trip.activities.first.aircraft

      json.id aircraft.id
      json.tail_number aircraft.tail_number
      json.seating_capacity aircraft.seating_capacity
      json.baggage_capacity_in_kg aircraft.baggage_capacity_in_kg
      json.runway_field_length_in_feet aircraft.runway_field_length_in_feet
      json.number_of_toilets aircraft.number_of_toilets
      json.cabin_width_in_meters aircraft.cabin_width_in_meters
      json.cabin_height_in_meters aircraft.cabin_height_in_meters
      json.crew aircraft.crew
      json.wifi aircraft.wifi
      json.phone aircraft.phone
      json.flight_attendant aircraft.flight_attendant
      json.year_of_manufacture aircraft.year_of_manufacture
      json.medical_evac aircraft.medical_evac
      json.cruise_speed_in_nm_per_hour aircraft.cruise_speed_in_nm_per_hour
      json.flying_range_in_nm aircraft.flying_range_in_nm
      json.per_hour_cost aircraft.per_hour_cost
      json.mtow aircraft.mtow
      # json.catering_cost_per_pax aircraft.catering_cost_per_pax
      json.is_working aircraft.is_working?
      json.flight_cost_commission_in_percentage aircraft.flight_cost_commission_in_percentage
      json.handling_cost_commission_in_percentage aircraft.handling_cost_commission_in_percentage
      json.accomodation_cost_commission_in_percentage aircraft.accomodation_cost_commission_in_percentage

      json.name aircraft.aircraft_type.name
      json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
    }

  end
}
