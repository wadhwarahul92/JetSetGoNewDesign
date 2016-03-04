class SearchAlgorithm

  def initialize(search_id)
    @search = Search.find search_id
    @results = []
  end

  def results
    find_aircrafts
    make_results
    make_intermediate_actvities
    @results
  end

  private

  def find_aircrafts
    verified_organisations = Organisation.where(admin_verified: true)
    verified_organisation_ids = verified_organisations.map(&:id)
    @aircrafts = Aircraft.where(
        organisation_id: verified_organisation_ids,
        admin_verified: true
    )
  end

  def make_results
    @aircrafts.each do |aircraft|

      next unless aircraft.ready_for_frontend?

      @results << {
          aircraft_id: aircraft.id,
          flight_plan: flight_plan(aircraft)
      }

    end
  end

  # @param [Aircraft] aircraft
  def flight_plan(aircraft)
    search_activities = @search.search_activities
    plan = []

    #########################
    # add initial ferry flight
    # And, landing cost at arrival airport
    #########################
    unless search_activities.first.departure_airport == aircraft.base_airport
      plan << {
          departure_airport_id: aircraft.base_airport.id,
          arrival_airport_id: search_activities.first.departure_airport.id,
          flight_type: 'empty_leg',
          start_at: search_activities.first.start_at - 45.minutes - aircraft.flight_time_in_hours_for(aircraft.base_airport, search_activities.first.departure_airport).hours ,
          end_at: search_activities.first.start_at - 45.minutes,
          landing_cost_at_arrival: search_activities.first.departure_airport.landing_cost,
          handling_cost_at_takeoff: aircraft.base_airport.handling_cost
      }
    end

    ##########################################
    # add plans for all user search activities
    ##########################################
    search_activities.each do |search_activity|
      plan << {
          departure_airport_id: search_activity.departure_airport.id,
          arrival_airport_id: search_activity.arrival_airport.id,
          flight_type: 'user_search',
          start_at: search_activity.start_at,
          end_at: search_activity.start_at + aircraft.flight_time_in_hours_for(search_activity.departure_airport, search_activity.arrival_airport).hours,
          landing_cost_at_arrival: search_activity.arrival_airport.landing_cost,
          handling_cost_at_takeoff: search_activity.departure_airport.handling_cost
      }
    end

    #######################
    # add last ferry flight
    #######################
    unless search_activities.last.arrival_airport == aircraft.base_airport
      plan << {
          departure_airport_id: search_activities.last.arrival_airport.id,
          arrival_airport_id: aircraft.base_airport.id,
          flight_type: 'empty_leg',
          start_at: plan.last[:end_at] + 45.minutes,
          end_at: plan.last[:end_at] + 45.minutes + aircraft.flight_time_in_hours_for(search_activities.last.arrival_airport, aircraft.base_airport).hours,
          landing_cost_at_arrival: aircraft.base_airport.landing_cost,
          handling_cost_at_takeoff: search_activities.last.arrival_airport.handling_cost
      }
    end

    #################################################
    # For every flight in plan, calculate flight cost
    #################################################
    plan.each do |flight|
      flight[:flight_cost] = TimeDifference.between(flight[:end_at], flight[:start_at]).in_hours * aircraft.per_hour_cost
    end

    ##############
    # return plan
    ##############
    plan

  end

  def make_intermediate_actvities

    @results.each do |result|

      previous_plan = nil

      result[:flight_plan].each_with_index do |plan, plan_index|

        if previous_plan.present?

          stay_time = TimeDifference.between(
              previous_plan[:end_at],
              plan[:start_at]
          ).in_hours

          if stay_time > 4

            nights = ( stay_time.to_i / 24 ) > 0 ? ( stay_time.to_i / 24 ) : 1

            previous_plan[:accommodation_plan] = {
                nights: nights,
                cost: Airport.find(previous_plan[:arrival_airport_id]).accommodation_cost(nights)
            }

          end

          if stay_time > 24

            aircraft = @aircrafts.find(result[:aircraft_id])

            departure_airport = Airport.find(previous_plan[:arrival_airport_id])

            arrival_airport = aircraft.base_airport

            unless departure_airport == arrival_airport

              previous_plan[:empty_leg_plan] = [
                  {
                      departure_airport_id: departure_airport.id,
                      arrival_airport_id: arrival_airport.id,
                      flight_type: 'empty_leg',
                      start_at: previous_plan[:end_at] + 45.minutes,
                      end_at: previous_plan[:end_at] + 45.minutes + aircraft.flight_time_in_hours_for(departure_airport, arrival_airport).hours,
                      landing_cost_at_arrival: arrival_airport.landing_cost,
                      handling_cost_at_takeoff: departure_airport.handling_cost,
                      flight_cost: aircraft.flight_time_in_hours_for(departure_airport, arrival_airport).hours * aircraft.per_hour_cost
                  },
                  {
                      departure_airport_id: arrival_airport.id,
                      arrival_airport_id: departure_airport.id,
                      flight_type: 'empty_leg',
                      start_at: plan[:start_at] - 45.minutes - aircraft.flight_time_in_hours_for(arrival_airport, departure_airport),
                      end_at: plan[:start_at] - 45.minutes,
                      landing_cost_at_arrival: departure_airport.landing_cost,
                      handling_cost_at_takeoff: arrival_airport.handling_cost,
                      flight_cost: aircraft.flight_time_in_hours_for(departure_airport, arrival_airport).hours * aircraft.per_hour_cost
                  }
              ]

            end

          end

        end

        previous_plan = plan

      end

    end

  end

end