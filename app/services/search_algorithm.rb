class SearchAlgorithm

  CONTINUOUS_FLIGHT_DELTA_TIME = 45.minutes

  #todo comment out all log printers
  def initialize(search_id)

    puts '==== Loading search from id'
    @search = Search.find(search_id)

    puts '==== Loading search activities'
    @search_activities = @search.search_activities.includes(:departure_airport, :arrival_airport)
    
    @results = []
  end

  def results
    find_aircrafts
    make_results
    # make_intermediate_activities
    @results
  end

  private

  def find_aircrafts

    puts '=== Loading verified organisations'
    verified_organisations = Organisation.where(admin_verified: true)

    puts '== Loading Aircrafts'
    @aircrafts = Aircraft.includes(:aircraft_images).where(
        organisation_id: verified_organisations.map(&:id),
        admin_verified: true
    )

    candidate_aircrafts_base_airport_ids = @aircrafts.map(&:base_airport_id)

    airport_ids = ( @search_activities.map(&:departure_airport_id) + @search_activities.map(&:arrival_airport_id) + candidate_aircrafts_base_airport_ids ).uniq

    puts '==== Loading Airports'
    @airports = Airport.where(id: airport_ids).to_a

    puts '==== Loading Distances'
    @distances = Distance.where(from_airport_id: @airports.map(&:id), to_airport_id: @airports.map(&:id)).to_a

  end

  def make_results
    @aircrafts.each do |aircraft|

      next unless aircraft.ready_for_frontend?

      @results << {
          aircraft_id: aircraft.id,
          flight_plan: flight_plan(aircraft),
      }

    end
  end

  # @param [Aircraft] aircraft
  def flight_plan(aircraft)
    search_activities = @search_activities
    plan = []

    #########################
    # add initial ferry flight
    # And, landing cost at arrival airport
    #########################
    unless search_activities.first.departure_airport_id == aircraft.base_airport_id
      plan << {
          departure_airport_id: aircraft.base_airport_id,
          arrival_airport_id: search_activities.first.departure_airport_id,
          flight_type: 'empty_leg',
          start_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), airport_for_id(search_activities.first.departure_airport_id)).hours ,
          end_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME,
          landing_cost_at_arrival: airport_for_id(search_activities.first.departure_airport_id).landing_cost,
          handling_cost_at_takeoff: base_airport(aircraft).handling_cost
      }
    end

    ##########################################
    # add plans for all user search activities
    ##########################################
    search_activities.each do |search_activity|
      # noinspection RubyResolve
      plan << {
          departure_airport_id: search_activity.departure_airport_id,
          arrival_airport_id: search_activity.arrival_airport_id,
          flight_type: 'user_search',
          start_at: search_activity.start_at,
          end_at: search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)).hours,
          landing_cost_at_arrival: airport_for_id(search_activity.arrival_airport_id).landing_cost,
          handling_cost_at_takeoff: airport_for_id(search_activity.departure_airport_id).handling_cost
      }
    end

    #######################
    # add last ferry flight
    #######################
    unless search_activities.last.arrival_airport_id == aircraft.base_airport_id
      plan << {
          departure_airport_id: search_activities.last.arrival_airport_id,
          arrival_airport_id: aircraft.base_airport_id,
          flight_type: 'empty_leg',
          start_at: plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
          end_at: plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)).hours,
          landing_cost_at_arrival: base_airport(aircraft).landing_cost,
          handling_cost_at_takeoff: airport_for_id(search_activities.last.arrival_airport_id).handling_cost
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

  def make_intermediate_activities

    @results.each do |result|

      previous_plan = nil

      result[:flight_plan].each do |plan|

        if previous_plan.present?

          stay_time = TimeDifference.between(
              previous_plan[:end_at],
              plan[:start_at]
          ).in_hours

          if stay_time > 4

            nights = ( stay_time.to_i / 24 ) > 0 ? ( stay_time.to_i / 24 ) : 1

            previous_plan[:accommodation_plan] = {
                nights: nights,
                cost: airport_for_id(previous_plan[:arrival_airport_id]).accommodation_cost(nights)
            }

            previous_plan[:chosen_intermediate_plan] = 'accommodation_plan'

          end

          if stay_time > 24

            aircraft = aircraft_for_id(result[:aircraft_id])

            departure_airport = airport_for_id(previous_plan[:arrival_airport_id])

            arrival_airport = base_airport(aircraft)

            unless departure_airport == arrival_airport

              previous_plan[:empty_leg_plan] = [
                  {
                      departure_airport_id: departure_airport.id,
                      arrival_airport_id: arrival_airport.id,
                      flight_type: 'empty_leg',
                      start_at: previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                      end_at: previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours,
                      landing_cost_at_arrival: arrival_airport.landing_cost,
                      handling_cost_at_takeoff: departure_airport.handling_cost,
                      flight_cost: flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours * aircraft.per_hour_cost
                  },
                  {
                      departure_airport_id: arrival_airport.id,
                      arrival_airport_id: departure_airport.id,
                      flight_type: 'empty_leg',
                      start_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport),
                      end_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME,
                      landing_cost_at_arrival: departure_airport.landing_cost,
                      handling_cost_at_takeoff: arrival_airport.handling_cost,
                      flight_cost: flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours * aircraft.per_hour_cost
                  }
              ]

              previous_plan[:chosen_intermediate_plan] = 'empty_leg_plan'

            end

          end

        end

        previous_plan = plan

      end

    end

  end

  ######################################################################
  # Description: This return the aircraft without hitting databse, uses cache
  # @param [Integer] id
  # @return [Aircraft]
  ######################################################################
  def aircraft_for_id(id)
    @aircrafts_map ||= {}
    return @aircrafts_map[id] if @aircrafts_map[id].present?
    @aircrafts_map[id] = @aircrafts.detect{ |aircraft| aircraft.id == id }
    @aircrafts_map[id]
  end
  
  ######################################################################
  # Description: Returns the base airport for given id, it uses the preloaded @airports and does not fire on DB
  # @param [Aircraft] aircraft
  # @return [Airport]
  ######################################################################
  def base_airport(aircraft)
    @base_airport_map ||= {}
    return @base_airport_map[aircraft.id] if @base_airport_map[aircraft.id].present?
    @base_airport_map[aircraft.id] = @airports.detect{ |airport| airport.id == aircraft.base_airport_id }
    @base_airport_map[aircraft.id]
  end
  
  ######################################################################
  # Description: This returns the airport for given id, This uses preloaded @airports and does not hit the database
  # @param [Integer] id
  # @return [Airport]
  ######################################################################
  def airport_for_id(id)
    @airport_id_map ||= {}
    return @airport_id_map[id] if @airport_id_map[id].present?
    @airport_id_map[id] = @airports.detect{ |airport| airport.id == id }
    @airport_id_map[id]
  end

  ######################################################################
  # Description: This returns the distance between airports without hitting database, uses cache
  # @param [Airport] departure_airport
  # @param [Airport] arrival_airport
  # @return [Float]
  ######################################################################
  def airport_distance_in_nm(departure_airport, arrival_airport)
    @distance_map ||= {}
    return @distance_map["#{departure_airport.id}-#{arrival_airport.id}"] if @distance_map["#{departure_airport.id}-#{arrival_airport.id}"].present?
    @distance_map["#{departure_airport.id}-#{arrival_airport.id}"] = @distances.detect{ |distance| distance.from_airport_id == departure_airport.id and distance.to_airport_id == arrival_airport.id }.distance_in_nm
    @distance_map["#{departure_airport.id}-#{arrival_airport.id}"]
  end

  ######################################################################
  # Description: It returns the time an aircraft takes to go A -> B, without hitting database
  # @param [Aircraft] aircraft
  # @param [Airport] departure_airport
  # @param [Airport] arrival_airport
  # @return [Float]
  ######################################################################
  def flight_time_in_hours(aircraft, departure_airport, arrival_airport)
    @flight_time_map ||= {}
    return @flight_time_map["#{aircraft.id}-#{departure_airport.id}-#{arrival_airport.id}"] if @flight_time_map["#{aircraft.id}-#{departure_airport.id}-#{arrival_airport.id}"].present?
    @flight_time_map["#{aircraft.id}-#{departure_airport.id}-#{arrival_airport.id}"] = airport_distance_in_nm(departure_airport, arrival_airport) / aircraft.cruise_speed_in_nm_per_hour
    @flight_time_map["#{aircraft.id}-#{departure_airport.id}-#{arrival_airport.id}"]
  end

end