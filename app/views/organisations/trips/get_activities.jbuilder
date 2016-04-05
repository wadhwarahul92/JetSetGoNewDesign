if @activities.present?
  json.activities{
    json.array! @activities do |activity|

      next unless @activities.any?
      json.tax Tax.tax
      json.tax_value Tax.total_tax_value

      json.id activity.id
      aircraft = activity.aircraft

      json.aircraft{
        json.id aircraft.id
        json.tail_number aircraft.tail_number
        json.images aircraft.aircraft_images.map{ |i| i.image.url(:size_250x250) }
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

if @enquiries.present?
  json.enquiries{
    json.array! @enquiries do |enquiry|

      next unless enquiry.activities.any?

      json.tax Tax.tax
      json.tax_value Tax.total_tax_value

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
  }
end

if @quotes.present?
  json.quotes{
    json.array! @quotes do |quote|

      next unless quote.activities.any?

      json.tax Tax.tax
      json.tax_value Tax.total_tax_value

      json.id quote.id
      json.status quote.status
      json.tax Tax.tax
      json.tax_value Tax.total_tax_value
      json.user quote.user.try(:full_name)

      json.activities{
        json.array! quote.activities do |activity|

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
  }
end

if @empty_legs.present?
  json.empty_legs{
    json.array! @empty_legs do |empty_leg|

      json.tax Tax.tax
      json.tax_value Tax.total_tax_value

      json.id empty_leg.id
      json.start_at empty_leg.start_at
      json.end_at empty_leg.end_at
      json.pax empty_leg.pax
      json.flight_cost empty_leg.flight_cost
      json.handling_cost_at_takeoff empty_leg.handling_cost_at_takeoff
      json.landing_cost_at_arrival empty_leg.landing_cost_at_arrival
      json.watch_hour_at_arrival empty_leg.watch_hour_at_arrival?
      json.watch_hour_cost empty_leg.watch_hour_cost

      if empty_leg.accommodation_plan.present?
        json.accommodation_plan{
          json.cost empty_leg.accommodation_plan[:cost]
          json.nights empty_leg.accommodation_plan[:nights]
        }
      end

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
        json.code empty_leg.departure_airport.code
      }

      json.arrival_airport{
        json.id empty_leg.arrival_airport.id
        json.name empty_leg.arrival_airport.name
        json.code empty_leg.arrival_airport.code
      }
    end
  }
end

if @aircraft_unavailabilities.present?
  json.aircraft_unavailabilities{
    json.array! @aircraft_unavailabilities do |aircraft_unavailability|
      json.id aircraft_unavailability.id
      json.title "#{aircraft_unavailability.aircraft.tail_number} - #{aircraft_unavailability.reason}"
      json.start aircraft_unavailability.start_at.to_s
      json.end aircraft_unavailability.end_at.to_s
      json.className ['aircraft_unavailability_event']
    end
  }
end