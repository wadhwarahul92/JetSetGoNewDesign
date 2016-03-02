class SearchAlgorithm

  def initialize(search_id)
    @search = Search.find search_id
    @results = []
  end

  def results
    find_aircrafts
    make_results
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
    #########################
    unless search_activities.first.departure_airport == aircraft.base_airport
      plan << {
          departure_airport_id: aircraft.base_airport.id,
          arrival_airport_id: search_activities.first.departure_airport.id,
          flight_type: 'ferry',
          start_at: search_activities.first.start_at - 45.minutes - aircraft.flight_time_in_hours_for(aircraft.base_airport, search_activities.first.departure_airport).hours ,
          end_at: search_activities.first.start_at - 45.minutes
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
          end_at: search_activity.start_at + aircraft.flight_time_in_hours_for(search_activity.departure_airport, search_activity.arrival_airport).hours
      }
    end

    #######################
    # add last ferry flight
    #######################
    unless search_activities.last.arrival_airport == aircraft.base_airport
      plan << {
          departure_airport_id: search_activities.last.arrival_airport.id,
          arrival_airport_id: aircraft.base_airport.id,
          flight_type: 'ferry',
          start_at: plan.last[:end_at] + 45.minutes,
          end_at: plan.last[:end_at] + 45.minutes + aircraft.flight_time_in_hours_for(search_activities.last.arrival_airport, aircraft.base_airport).hours
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

end