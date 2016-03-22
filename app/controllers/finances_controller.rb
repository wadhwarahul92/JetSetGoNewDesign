class FinancesController < ApplicationController

  TOKEN = ENV['FINANCE_TOKEN']
  PASSWORD = ENV['FINANCE_PASSWORD']

  if Rails.env.development?
    URL = 'http://localhost:3001/api/v1'
  else
    URL = 'http://jet-set-go-finance.herokuapp.com/api/v1'
  end

  # noinspection RailsChecklist01
  def preview_pro_forma

    itinerary_charges = []

    handling_charges = []

    accommodation_charges = []

    miscellaneous_charges = []

    params[:result][:flight_plan].each do |plan|

      departure_airport = Airport.find(plan[:departure_airport_id])

      arrival_airport = Airport.find(plan[:arrival_airport_id])

      itinerary_charges << {
          aircraft: aircraft_,
          jsg_adjusted: params[:result][:aircraft][:per_hour_cost],
          departure_airport: departure_airport.name,
          arrival_airport: arrival_airport.name,
          flight_time_hour: hour_diff(plan[:start_at], plan[:end_at]),
          flight_time_min: min_diff(plan[:start_at], plan[:end_at]),
      }

      handling_charges << {
          city: arrival_airport.city.name,
          jsg_adjusted: plan['handling_cost_at_takeoff']
      }

      miscellaneous_charges << {
          description: "Landing at #{arrival_airport.name}",
          charge: plan['landing_cost_at_arrival']
      }

      if plan['watch_hour_at_arrival']

        miscellaneous_charges << {
            description: "Watch hour at #{arrival_airport.name}",
            charge: plan['watch_hour_cost']
        }

      end

      if plan[:chosen_intermediate_plan].present? and plan[:chosen_intermediate_plan] == 'accommodation_plan'

        accommodation_charges << {
          city: arrival_airport.city.name,
          number_of_crew: 3,
          jsg_adjusted: plan[:accommodation_plan][:cost],
          number_of_nights: plan[:accommodation_plan][:nights]
        }

      end

      if plan[:chosen_intermediate_plan].present? and plan[:chosen_intermediate_plan] == 'empty_leg_plan'

        plan[:empty_leg_plan].each do |elp|

          departure_airport = Airport.find(elp[:departure_airport_id])

          arrival_airport = Airport.find(elp[:arrival_airport_id])

          itinerary_charges << {
              aircraft: aircraft_,
              jsg_adjusted: params[:result][:aircraft][:per_hour_cost],
              departure_airport: departure_airport.name,
              arrival_airport: arrival_airport.name,
              flight_time_hour: hour_diff(elp[:start_at], elp[:end_at]),
              flight_time_min: min_diff(elp[:start_at], elp[:end_at]),
          }

          handling_charges << {
              city: arrival_airport.city.name,
              jsg_adjusted: elp['handling_cost_at_takeoff']
          }

          miscellaneous_charges << {
              description: "Landing at #{arrival_airport.name}",
              charge: elp['landing_cost_at_arrival']
          }

          if elp['watch_hour_at_arrival']

            miscellaneous_charges << {
                description: "Watch hour at #{arrival_airport.name}",
                charge: elp['watch_hour_cost']
            }

          end

        end

      end

    end

    response = HTTParty.post("#{URL}/pro_forma_preview?format=pdf", body: {
        client_name: current_user.full_name,
        client_address: '--',
        itinerary_charges: itinerary_charges,
        handling_charges: handling_charges,
        accommodation_charges: accommodation_charges,
        miscellaneous_charges: miscellaneous_charges,
        token: TOKEN,
        pass: PASSWORD
    }.to_json,:headers => { 'Content-Type' => 'application/json' })

    if response.code == 200
      send_data response.body
    else
      render status: :unprocessable_entity, nothing: true
    end

  end

  private

  def hour_diff(start_at, end_at)
    hours = TimeDifference.between(start_at, end_at).in_hours
    hours.to_i
  end

  def min_diff(start_at, end_at)
    hours = TimeDifference.between(start_at, end_at).in_hours
    decimal_part = hours.to_s.split('.')[1]
    decimal_part.present? ? decimal_part.to_i : 0
  end

  def aircraft_
    "#{params[:result][:aircraft][:aircraft_type][:name]}, #{params[:result][:aircraft][:tail_number]}"
  end

end