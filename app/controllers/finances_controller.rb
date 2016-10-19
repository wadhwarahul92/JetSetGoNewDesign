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

    total_handling_charges = []

    handling_charges = []

    accommodation_charges = []

    miscellaneous_charges = []

    @is_watch_hour = false

    params[:result][:flight_plan].each do |plan|

      trip_type = ''

      departure_airport = Airport.find(plan[:departure_airport_id])

      arrival_airport = Airport.find(plan[:arrival_airport_id])


      if plan[:flight_type] == 'empty_leg' and departure_airport.id == params[:result][:aircraft][:base_airport][:id]
        trip_type = 'Positioning'
      elsif plan[:flight_type] == 'empty_leg' and arrival_airport.id == params[:result][:aircraft][:base_airport][:id]
        trip_type = 'Re - Positioning'
      else
        trip_type = 'With Pax'
      end

      itinerary_charges << {
          aircraft: aircraft_,
          jsg_adjusted: (params[:result][:aircraft][:per_hour_cost] + (params[:result][:aircraft][:per_hour_cost] * (params[:result][:aircraft][:flight_cost_commission_in_percentage]/100.to_f))),
          departure_airport: departure_airport.city.name,
          arrival_airport: arrival_airport.city.name,
          start_at: plan[:start_at].to_s.to_datetime.strftime('%d %b %Y, %I:%M %p'),
          end_at: plan[:end_at].to_s.to_datetime.strftime('%d %b %Y, %I:%M %p'),
          flight_time_hour: hour_diff(plan[:start_at], plan[:end_at]),
          flight_time_min: min_diff(plan[:start_at], plan[:end_at]),
          flight_time_sec: sec_diff(plan[:start_at], plan[:end_at]),
          plan_trip_type: trip_type,
      }

      handling_charges << {
          city: arrival_airport.city.name,
          jsg_adjusted: (plan['handling_cost_at_takeoff'] + (plan['handling_cost_at_takeoff'] * params[:result][:aircraft][:handling_cost_commission_in_percentage]/100.to_f))
      }

      handling_charges << {
          city: "Landing at #{arrival_airport.city.name}",
          jsg_adjusted: (plan['landing_cost_at_arrival'] + (plan['landing_cost_at_arrival'] * params[:result][:aircraft][:handling_cost_commission_in_percentage]/100.to_f))
      }

      # if plan['watch_hour_at_arrival']
      #   miscellaneous_charges << {
      #       description: "Watch hour at #{arrival_airport.city.name}",
      #       charge: plan['watch_hour_cost']
      #   }
      # end

      if plan['watch_hour_at_arrival']
         @is_watch_hour = true
      end

      if plan['accommodation_leg']
        accommodation_charges << {
            city: arrival_airport.city.name,
            number_of_crew: 3,
            jsg_adjusted: plan['accommodation_leg'][:cost] + (plan['accommodation_leg'][:cost] * params[:result][:aircraft][:accomodation_cost_commission_in_percentage]/100.to_f),
            number_of_nights: plan['accommodation_leg'][:nights]
        }
      end

      # if plan[:chosen_intermediate_plan].present? and plan[:chosen_intermediate_plan] == 'accommodation_plan'
      #
      #   accommodation_charges << {
      #     city: arrival_airport.city.name,
      #     number_of_crew: 3,
      #     jsg_adjusted: plan[:accommodation_plan][:cost],
      #     number_of_nights: plan[:accommodation_plan][:nights]
      #   }
      #
      # end
      #
      # if plan[:chosen_intermediate_plan].present? and plan[:chosen_intermediate_plan] == 'empty_leg_plan'
      #
      #   plan[:empty_leg_plan].each do |elp|
      #
      #     departure_airport = Airport.find(elp[:departure_airport_id])
      #
      #     arrival_airport = Airport.find(elp[:arrival_airport_id])
      #
      #     itinerary_charges << {
      #         aircraft: aircraft_,
      #         jsg_adjusted: params[:result][:aircraft][:per_hour_cost],
      #         departure_airport: departure_airport.name,
      #         arrival_airport: arrival_airport.name,
      #         flight_time_hour: hour_diff(elp[:start_at], elp[:end_at]),
      #         flight_time_min: min_diff(elp[:start_at], elp[:end_at]),
      #     }
      #
      #     handling_charges << {
      #         city: arrival_airport.city.name,
      #         jsg_adjusted: elp['handling_cost_at_takeoff']
      #     }
      #
      #     miscellaneous_charges << {
      #         description: "Landing at #{arrival_airport.name}",
      #         charge: elp['landing_cost_at_arrival']
      #     }
      #
      #     if elp['watch_hour_at_arrival']
      #
      #       miscellaneous_charges << {
      #           description: "Watch hour at #{arrival_airport.name}",
      #           charge: elp['watch_hour_cost']
      #       }
      #
      #     end
      #
      #   end
      #
      # end

    end

    if handling_charges.present?
      amount = 0.0
      for charges in handling_charges
        amount += charges[:jsg_adjusted]
      end

      total_handling_charges << {
          jsg_adjusted: (amount)
      }
    end



    if params[:result][:is_miscellaneous_expenses].present?
      miscellaneous_charges << {
          description: "Miscellaneous expenses",
          charge: params[:result][:miscellaneous_expenses_amount]
      }
    end


    # response = HTTParty.post("#{URL}/pro_forma_preview?format=pdf", body: {
    #     client_name: current_user.full_name,
    #     client_address: '--',
    #     itinerary_charges: itinerary_charges,
    #     handling_charges: handling_charges,
    #     accommodation_charges: accommodation_charges,
    #     miscellaneous_charges: miscellaneous_charges,
    #     token: TOKEN,
    #     pass: PASSWORD
    # }.to_json,:headers => { 'Content-Type' => 'application/json' })


    response = HTTParty.post("#{URL}/pro_forma_preview_2?format=pdf", body: {
                                                                        uniq_id:  params[:uniq_id],
                                                                        client_address: '--',
                                                                        itinerary_charges: itinerary_charges,
                                                                        handling_charges: total_handling_charges,
                                                                        accommodation_charges: accommodation_charges,
                                                                        miscellaneous_charges: miscellaneous_charges,
                                                                        is_watch_hour: @is_watch_hour,
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
    start_at = DateTime.parse(start_at) if start_at.is_a?(String)
    end_at = DateTime.parse(end_at) if end_at.is_a?(String)
    hours = TimeDifference.between(start_at, end_at).in_hours
    hours.to_i
  end

  def min_diff(start_at, end_at)
    start_at = DateTime.parse(start_at) if start_at.is_a?(String)
    end_at = DateTime.parse(end_at) if end_at.is_a?(String)
    hours = TimeDifference.between(start_at, end_at).in_hours
    decimal_part = hours.to_s.split('.')[1]
    decimal_part.present? ? decimal_part.to_i : 0
  end

  def sec_diff(start_at, end_at)
    start_at = DateTime.parse(start_at) if start_at.is_a?(String)
    end_at = DateTime.parse(end_at) if end_at.is_a?(String)
    hours = TimeDifference.between(start_at, end_at).in_hrs_mins_secs
    decimal_part = hours.to_s.split('.')[2]
    decimal_part.present? ? decimal_part.to_i : 0
  end

  def aircraft_
    "#{params[:result][:aircraft][:aircraft_type][:name]}"
  end

end