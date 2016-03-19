# noinspection RubyTooManyInstanceVariablesInspection
class SearchAlgorithm

  CONTINUOUS_FLIGHT_DELTA_TIME = 45.minutes

  def initialize(search_id)

    # puts '==== Loading search from id'
    @search = Search.find(search_id)

    # puts '==== Loading search activities'
    @search_activities = @search.search_activities

    @results = []
  end

  def results
    find_aircrafts_and_load_models
    make_results
    make_intermediate_activities
    @results
  end

  private

  def find_aircrafts_and_load_models

    # puts '=== Loading verified organisations'
    verified_organisations = Organisation.where(admin_verified: true)

    max_pax = @search_activities.map(&:pax).max

    # puts '== Loading Aircrafts'
    @aircrafts = Aircraft.where(
        organisation_id: verified_organisations.map(&:id),
        admin_verified: true
    ).where(
        'seating_capacity >= ?', max_pax
    )

    candidate_aircrafts_base_airport_ids = @aircrafts.map(&:base_airport_id)

    airport_ids = ( @search_activities.map(&:departure_airport_id) + @search_activities.map(&:arrival_airport_id) + candidate_aircrafts_base_airport_ids ).uniq

    # puts '==== Loading Airports'
    @airports = Airport.where(id: airport_ids).to_a

    # puts '==== Loading cities'
    @cities = City.where(id: @airports.map(&:city_id)).to_a

    # puts '==== Loading Distances'
    @distances = Distance.where(from_airport_id: @airports.map(&:id), to_airport_id: @airports.map(&:id)).to_a

    # puts '==== Loading Aircraft Images count'
    @aircraft_images_count = ActiveRecord::Base.connection.execute(
        <<BEGIN
SELECT aircraft_id, COUNT(aircraft_images.id)
FROM aircraft_images
WHERE aircraft_id IN (#{ @aircrafts.map(&:id).join(',').presence || '0' })
GROUP BY aircraft_id
BEGIN
    ).to_h

  end

  def make_results
    @aircrafts.each do |aircraft|

      next unless aircraft_ready_for_frontend?(aircraft)

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
          pax: 0,
          departure_airport_id: aircraft.base_airport_id,
          arrival_airport_id: search_activities.first.departure_airport_id,
          flight_type: 'empty_leg',
          start_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), airport_for_id(search_activities.first.departure_airport_id)).hours ,
          end_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME,
          landing_cost_at_arrival: airport_for_id(search_activities.first.departure_airport_id).landing_cost,
          handling_cost_at_takeoff: base_airport(aircraft).handling_cost,
          #todo optimise this
          watch_hour_at_arrival: WatchHour.where(
              airport_id: search_activities.first.departure_airport_id
          ).where(
              '? BETWEEN start_at AND end_at', search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME
          ).any?,
          watch_hour_cost: (WatchHour.where(airport_id: search_activities.first.departure_airport_id).first.try(:cost) || 0),
          notam_at_arrival: Notam.where(airport_id: search_activities.first.departure_airport_id).where(
              '? BETWEEN start_at AND end_at', search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME
          ).any?
      }
    end

    ##########################################
    # add plans for all user search activities
    ##########################################
    search_activities.each do |search_activity|
      # noinspection RubyResolve
      plan << {
          pax: search_activity.pax,
          departure_airport_id: search_activity.departure_airport_id,
          arrival_airport_id: search_activity.arrival_airport_id,
          flight_type: 'user_search',
          start_at: search_activity.start_at,
          end_at: search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)).hours,
          landing_cost_at_arrival: airport_for_id(search_activity.arrival_airport_id).landing_cost,
          handling_cost_at_takeoff: airport_for_id(search_activity.departure_airport_id).handling_cost,
          #todo optimise this
          watch_hour_at_arrival: WatchHour.where(
              airport_id: search_activity.departure_airport_id
          ).where(
              '? BETWEEN start_at AND end_at', search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)).hours
          ).any?,
          watch_hour_cost: (WatchHour.where(airport_id: search_activity.departure_airport_id).first.try(:cost) || 0),
          notam_at_arrival: Notam.where(airport_id: search_activities.first.departure_airport_id).where(
              '? BETWEEN start_at AND end_at', search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)).hours
          ).any?
      }
    end

    #######################
    # add last ferry flight
    #######################
    unless search_activities.last.arrival_airport_id == aircraft.base_airport_id
      plan << {
          pax: 0,
          departure_airport_id: search_activities.last.arrival_airport_id,
          arrival_airport_id: aircraft.base_airport_id,
          flight_type: 'empty_leg',
          start_at: plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
          end_at: plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)).hours,
          landing_cost_at_arrival: base_airport(aircraft).landing_cost,
          handling_cost_at_takeoff: airport_for_id(search_activities.last.arrival_airport_id).handling_cost,
          #todo optimise this
          watch_hour_at_arrival: WatchHour.where(
              airport_id: aircraft.base_airport_id
          ).where(
              '? BETWEEN start_at AND end_at', plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)).hours
          ).any?,
          watch_hour_cost: (WatchHour.where(airport_id: aircraft.base_airport_id).first.try(:cost) || 0),
          notam_at_arrival: Notam.where(airport_id: search_activities.first.departure_airport_id).where(
              '? BETWEEN start_at AND end_at', plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)).hours
          ).any?
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
                cost: accommodation_cost_at_airport(airport_for_id(previous_plan[:arrival_airport_id]), nights)
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
                      pax: 0,
                      departure_airport_id: departure_airport.id,
                      arrival_airport_id: arrival_airport.id,
                      flight_type: 'empty_leg',
                      start_at: previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                      end_at: previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours,
                      landing_cost_at_arrival: arrival_airport.landing_cost,
                      handling_cost_at_takeoff: departure_airport.handling_cost,
                      flight_cost: TimeDifference.between(
                          previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                          previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours
                      ).in_hours * aircraft.per_hour_cost,
                      #todo optimise this
                      watch_hour_at_arrival: WatchHour.where(
                          airport_id: arrival_airport.id
                      ).where(
                          '? BETWEEN start_at AND end_at', previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours
                      ).any?,
                      watch_hour_cost: (WatchHour.where(airport_id: arrival_airport.id).first.try(:cost) || 0),
                      notam_at_arrival: Notam.where(airport_id: search_activities.first.departure_airport_id).where(
                          '? BETWEEN start_at AND end_at', previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport).hours
                      ).any?
                  },
                  {
                      pax: 0,
                      departure_airport_id: arrival_airport.id,
                      arrival_airport_id: departure_airport.id,
                      flight_type: 'empty_leg',
                      start_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport),
                      end_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME,
                      landing_cost_at_arrival: departure_airport.landing_cost,
                      handling_cost_at_takeoff: arrival_airport.handling_cost,
                      flight_cost: TimeDifference.between(
                          plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport).hours,
                          plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
                      ).in_hours * aircraft.per_hour_cost,
                      #todo optimise this
                      watch_hour_at_arrival: WatchHour.where(
                          airport_id: departure_airport.id
                      ).where(
                          '? BETWEEN start_at AND end_at', plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
                      ).any?,
                      watch_hour_cost: (WatchHour.where(airport_id: departure_airport.id).first.try(:cost) || 0),
                      notam_at_arrival: Notam.where(airport_id: search_activities.first.departure_airport_id).where(
                          '? BETWEEN start_at AND end_at', plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
                      ).any?
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
  # Description: This return the aircraft without hitting database, uses cache
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

  ######################################################################
  # Description: This tells whether the aircraft is ready to be shown on frontend or not
  # @param [Aircraft] aircraft
  # @return [Boolean]
  ######################################################################
  def aircraft_ready_for_frontend?(aircraft)
    @aircraft_images_count[aircraft.id].present? and @aircraft_images_count[aircraft.id] > 0 and aircraft.admin_verified?
  end

  ######################################################################
  # Description: It returns the city of airport without hitting database
  # @param [Airport] airport
  # @return [City]
  ######################################################################
  def city_for_airport(airport)
    @city_map ||= {}
    return @city_map[airport.id] if @city_map[airport.id].present?
    @city_map[airport.id] = @cities.detect{ |city| city.id == airport.city_id }
    @city_map[airport.id]
  end

  ######################################################################
  # Description: It returns the cost of accommodation at an airport according to number of nights, uses cache
  # @param [Airport] airport
  # @param [Integer] nights
  # @return [Float]
  ######################################################################
  def accommodation_cost_at_airport(airport, nights)
    @accommodation_cost_map ||= {}
    return @accommodation_cost_map["#{airport.id}-#{nights}"] if @accommodation_cost_map["#{airport.id}-#{nights}"].present?
    @accommodation_cost_map["#{airport.id}-#{nights}"] = City::TIER_ACCOMMODATION_COST[city_for_airport(airport).accomodation_category.to_sym] * nights
    @accommodation_cost_map["#{airport.id}-#{nights}"]
  end

end