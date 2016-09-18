# noinspection RubyTooManyInstanceVariablesInspection
class SearchAlgorithm

  CONTINUOUS_FLIGHT_DELTA_TIME = 60.minutes

  def initialize(search_id)

    # puts '==== Loading search from id'
    @search = Search.find(search_id)

    # puts '==== Loading search activities'
    @search_activities = @search.search_activities

    @results = []

    @airport_details = []
  end

  def results
    find_aircrafts_and_load_models
    make_results
    # make_intermediate_activities
    @results
  end

  def search_activities
    @search_activities
  end

  def airport_break_ups
    find_aircrafts_and_load_models
    check_airport_availablity(@search_activities)
  end

  private

  def find_aircrafts_and_load_models

    # puts '=== Loading verified organisations'
    verified_organisations = Organisation.where(admin_verified: true)

    max_pax = @search_activities.map(&:pax).max

    max_runway_length = airport_max_field_for_landing(@search_activities)

    #find search start_time and search end_time
    #all find a time duration during which if aircraft is unavailable, it can be safely removed from search algorithm
    @start_time_for_unavailability = @search_activities.first.start_at - 3.hours
    @end_time_for_unavailability = @search_activities.last.start_at + 5.hours

    # puts '== Loading Aircrafts'
    @aircrafts = Aircraft.where(
        organisation_id: verified_organisations.map(&:id),
        admin_verified: true
    ).where(
        'seating_capacity >= ? AND landing_field_length_in_feet <= ? AND runway_field_length_in_feet <= ?', max_pax, max_runway_length, max_runway_length
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

    # puts '=== Loading Watch hours'
    @watch_hours = WatchHour.where(airport_id: airport_ids).where('end_at >= ?', DateTime.now).to_a

    # puts '=== Loading Notams'
    @notams = Notam.where(airport_id: airport_ids).where('start_at >= ?', DateTime.now).to_a

    # puts '=== Loading HandlingCostGrid'
    @handling_cost_grids = HandlingCostGrid.all.to_a

    # puts '=== Loading HandlingCostGrid'
    @aircraft_types = AircraftType.where(id: @aircrafts.map(&:aircraft_type_id)).to_a

    # puts '=== Loading AircraftUnavailability'
    @aircraft_unavailabilities = AircraftUnavailability.where(aircraft_id: @aircrafts.map(&:id)).to_a

    @trips = Trip.where(status: 'confirmed' ).to_a
    trip_ids =  @trips.map(&:id)
    @activities = Activity.where(trip_id: trip_ids ).to_a

  end

  def make_results
    @aircrafts.each do |aircraft|

      next unless aircraft_ready_for_frontend?(aircraft)

      # next unless aircraft_has_night_landing?(aircraft)

      next if aircraft_has_unavailability(aircraft)

      next unless aircraft_has_flying_range(aircraft)

      # next if aircraft_has_trip(aircraft)

      @results << {
          # aircraft: aircraft,
          aircraft_id: aircraft.id,
          aircraft_per_hour_cost: aircraft.per_hour_cost,
          # aircraft_flight_cost_commission_in_percentage: aircraft.flight_cost_commission_in_percentage,
          # aircraft_handling_cost_commission_in_percentage: aircraft.handling_cost_commission_in_percentage,
          # aircraft_accomodation_cost_commission_in_percentage: aircraft.accomodation_cost_commission_in_percentage,
          # aircraft_type_category: aircraft.aircraft_type.aircraft_category.name,
          # aircraft_seating_capacity: aircraft.seating_capacity,
          # aircraft_type_name: aircraft.aircraft_type.name,
          # aircraft_tail_number: aircraft.tail_number,
          # aircraft_image: aircraft.image.url(:original),
          # aircraft_interior_image: aircraft.interior.url(:original),
          flight_plan: flight_plan(aircraft),
      }

      is_overriding_activities(aircraft)

    end
  end

  # @param [Aircraft] aircraft
  def flight_plan(aircraft)
    search_activities = @search_activities
    plan = []
    previous_leg = nil

    # @handling_cost_grids.detect{|h| h.city_id == search_activities.last.arrival_airport_id and  h.aircraft_category_id ==  aircraft.aircraft_type.aircraft_category.id  }

    #########################
    # add initial ferry flight
    # And, landing cost at arrival airport
    #########################
    # aircraft.aircraft_type.aircraft_category.id
    unless search_activities.first.departure_airport_id == aircraft.base_airport_id
      plan << {
          pax: 0,
          departure_airport_id: aircraft.base_airport_id,
          arrival_airport_id: search_activities.first.departure_airport_id,
          flight_type: 'empty_leg',
          start_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), airport_for_id(search_activities.first.departure_airport_id)),
          end_at: search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME,
          landing_cost_at_arrival: airport_for_id(search_activities.first.departure_airport_id).landing_cost,
          handling_cost_at_takeoff: get_handling_cost(aircraft, airport_for_id(aircraft.base_airport_id)),
          watch_hour_at_arrival: airport_has_watch_hour(search_activities.first.departure_airport_id, search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME)[0],
          watch_hour_cost: airport_has_watch_hour(search_activities.first.departure_airport_id, search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME)[1],
          notam_at_arrival: airport_has_notam(search_activities.first.departure_airport_id, search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME),
          flight_cost: flight_cost_for_aircraft(aircraft, search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), airport_for_id(search_activities.first.departure_airport_id)), search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME),
          flight_time: Time.diff(
              search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), airport_for_id(search_activities.first.departure_airport_id)),
              search_activities.first.start_at - CONTINUOUS_FLIGHT_DELTA_TIME
          )[:diff]
      }
    end

    ##########################################
    # add plans for all user search activities
    ##########################################
    search_activities.each do |search_activity|

      if previous_leg.present?

        # if search_activity.departure_airport == airport_for_id(previous_leg.last[:arrival_airport_id])
        # unless search_activity.departure_airport_id == aircraft.base_airport_id
        #
        #   accommodation_plan = nil
        #
        #   stay_time = TimeDifference.between(
        #       previous_leg.last[:end_at],
        #       search_activity[:start_at]
        #   ).in_hours.to_f
        #
        #   stay_time = (stay_time - 5) if stay_time > 4
        #
        #   if stay_time > 4 && stay_time < 48
        #
        #     nights = (stay_time.to_i / 24) + 1
        #
        #     accommodation_plan = {
        #         nights:  nights,
        #         cost: accommodation_cost_at_airport(airport_for_id(previous_leg.last[:arrival_airport_id]), nights)
        #     }
        #
        #     plan.last.merge!(accommodation_leg: accommodation_plan)
        #
        #   end
        #
        #   if stay_time > 48
        #     plan << {
        #         pax: 0,
        #         departure_airport_id: previous_leg.last[:arrival_airport_id],
        #         arrival_airport_id: aircraft.base_airport_id,
        #         flight_type: 'empty_leg',
        #         start_at: previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
        #         end_at: previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)),
        #         landing_cost_at_arrival: base_airport(aircraft).landing_cost,
        #         handling_cost_at_takeoff: get_handling_cost(aircraft, base_airport(aircraft)),
        #         watch_hour_at_arrival: airport_has_watch_hour(aircraft.base_airport_id, previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)))[0],
        #         watch_hour_cost: airport_has_watch_hour(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)))[1],
        #         notam_at_arrival: airport_has_notam(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))),
        #         flight_cost: flight_cost_for_aircraft(aircraft,
        #                                               previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
        #                                               previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))),
        #         flight_time: Time.diff(
        #             previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
        #             previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))
        #         )[:diff]
        #     }
        #     plan << {
        #         pax: 0,
        #         departure_airport_id: aircraft.base_airport_id,
        #         arrival_airport_id: search_activity.departure_airport.id,
        #         flight_type: 'empty_leg',
        #         start_at: search_activity.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), search_activity.departure_airport),
        #         end_at: search_activity.start_at - CONTINUOUS_FLIGHT_DELTA_TIME,
        #         landing_cost_at_arrival: search_activity.departure_airport.landing_cost,
        #         handling_cost_at_takeoff:  get_handling_cost(aircraft, search_activity.arrival_airport),
        #         watch_hour_at_arrival: airport_has_watch_hour(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[0],
        #         watch_hour_cost: airport_has_watch_hour(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[1],
        #         notam_at_arrival: airport_has_notam(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
        #         flight_cost: flight_cost_for_aircraft(aircraft,
        #                                               previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, search_activity.departure_airport,  airport_for_id(previous_leg.last[:arrival_airport_id])), previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
        #         flight_time: Time.diff(
        #             previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, search_activity.departure_airport,  airport_for_id(previous_leg.last[:arrival_airport_id])),
        #             previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
        #         )[:diff]
        #     }
        #   end
        # end

        # ================
        unless search_activity.departure_airport_id == aircraft.base_airport_id

          accommodation_plan = nil

          stay_time = TimeDifference.between(
              previous_leg.last[:end_at],
              search_activity[:start_at]
          ).in_hours.to_f




          nights = (stay_time.to_i / 24) + 1
          accommodationCost = accommodation_cost_at_airport(airport_for_id(previous_leg.last[:arrival_airport_id]), nights)

          emptyLegPlanCost = calculate_empty_leg_plan_cost(aircraft, previous_leg, search_activity)

          if accommodationCost > emptyLegPlanCost
            is_aircraft_return = true
          else
            is_aircraft_return = false
          end

          if stay_time > 4 && !is_aircraft_return


            accommodation_plan = {
                nights:  nights,
                cost: accommodationCost
            }

            plan.last.merge!(accommodation_leg: accommodation_plan)

          end

          if is_aircraft_return
            plan << {
                pax: 0,
                departure_airport_id: previous_leg.last[:arrival_airport_id],
                arrival_airport_id: aircraft.base_airport_id,
                flight_type: 'empty_leg',
                start_at: previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                end_at: previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)),
                landing_cost_at_arrival: base_airport(aircraft).landing_cost,
                handling_cost_at_takeoff: get_handling_cost(aircraft, base_airport(aircraft)),
                watch_hour_at_arrival: airport_has_watch_hour(aircraft.base_airport_id, previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)))[0],
                watch_hour_cost: airport_has_watch_hour(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)))[1],
                notam_at_arrival: airport_has_notam(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))),
                flight_cost: flight_cost_for_aircraft(aircraft,
                                                      previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                                                      previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))),
                flight_time: Time.diff(
                    previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                    previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft))
                )[:diff]
            }
            plan << {
                pax: 0,
                departure_airport_id: aircraft.base_airport_id,
                arrival_airport_id: search_activity.departure_airport.id,
                flight_type: 'empty_leg',
                start_at: search_activity.start_at - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, base_airport(aircraft), search_activity.departure_airport),
                end_at: search_activity.start_at - CONTINUOUS_FLIGHT_DELTA_TIME,
                landing_cost_at_arrival: search_activity.departure_airport.landing_cost,
                handling_cost_at_takeoff: get_handling_cost(aircraft, search_activity.arrival_airport),
                watch_hour_at_arrival: airport_has_watch_hour(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[0],
                watch_hour_cost: airport_has_watch_hour(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[1],
                notam_at_arrival: airport_has_notam(search_activity.departure_airport.id, previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
                flight_cost: flight_cost_for_aircraft(aircraft,
                                                      previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, search_activity.departure_airport,  airport_for_id(previous_leg.last[:arrival_airport_id])), previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
                flight_time: Time.diff(
                    previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, search_activity.departure_airport,  airport_for_id(previous_leg.last[:arrival_airport_id])),
                    previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
                )[:diff]
            }
          end
        end
        # ================
      end

      # noinspection RubyResolve
      plan << {
          pax: search_activity.pax,
          departure_airport_id: search_activity.departure_airport_id,
          arrival_airport_id: search_activity.arrival_airport_id,
          flight_type: 'user_search',
          start_at: search_activity.start_at,
          end_at: search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)),
          landing_cost_at_arrival: airport_for_id(search_activity.arrival_airport_id).landing_cost,
          handling_cost_at_takeoff: get_handling_cost(aircraft, airport_for_id(search_activity.departure_airport_id)),
          watch_hour_at_arrival: airport_has_watch_hour(
              search_activity.arrival_airport_id,
              search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id))
          )[0],
          watch_hour_cost: airport_has_watch_hour(
              search_activity.arrival_airport_id,
              search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id))
          )[1],
          notam_at_arrival: airport_has_notam(search_activity.arrival_airport_id, search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id))),
          flight_cost: flight_cost_for_aircraft(aircraft,
                                                search_activity.start_at,
                                                search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id))),
          flight_time: Time.diff(
              search_activity.start_at,
              search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id))
          )[:diff]
      }

      previous_leg = plan
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
          end_at: plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)),
          landing_cost_at_arrival: base_airport(aircraft).landing_cost,
          handling_cost_at_takeoff: get_handling_cost(aircraft, airport_for_id(search_activities.last.arrival_airport_id)),
          watch_hour_at_arrival: airport_has_watch_hour(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)))[0],
          watch_hour_cost: airport_has_watch_hour(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft)))[1],
          notam_at_arrival: airport_has_notam(aircraft.base_airport_id, plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft))),
          flight_cost: flight_cost_for_aircraft(aircraft,
                                                plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                                                plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft))),
          flight_time: Time.diff(
              plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
              plan.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(search_activities.last.arrival_airport_id), base_airport(aircraft))
          )[:diff]
      }
    end

    #################################################
    # For every flight in plan, calculate flight cost
    #################################################
    ###**DEPRECATED***
    # plan.each do |flight|
    #   flight[:flight_cost] = TimeDifference.between(flight[:end_at], flight[:start_at]).in_hours * aircraft.per_hour_cost
    # end
    ###**DEPRECATED***

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
          ).in_hours.to_f

          if stay_time > 4

            nights =  (stay_time.to_i / 24) + 1

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
                      end_at: previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport),
                      landing_cost_at_arrival: arrival_airport.landing_cost,
                      handling_cost_at_takeoff: get_handling_cost(aircraft, departure_airport),
                      watch_hour_at_arrival: airport_has_watch_hour(arrival_airport.id, previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport))[0],
                      watch_hour_cost: airport_has_watch_hour(arrival_airport.id, previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport))[1],
                      notam_at_arrival: airport_has_notam(arrival_airport.id, previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport)),
                      flight_cost: flight_cost_for_aircraft(aircraft, previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME, previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport)),
                      flight_time: Time.diff(
                          previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                          previous_plan[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, departure_airport, arrival_airport)
                      )[:diff]
                  },
                  {
                      pax: 0,
                      departure_airport_id: arrival_airport.id,
                      arrival_airport_id: departure_airport.id,
                      flight_type: 'empty_leg',
                      start_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport),
                      end_at: plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME,
                      landing_cost_at_arrival: departure_airport.landing_cost,
                      handling_cost_at_takeoff: get_handling_cost(aircraft, arrival_airport),
                      watch_hour_at_arrival: airport_has_watch_hour(departure_airport.id, plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[0],
                      watch_hour_cost: airport_has_watch_hour(departure_airport.id, plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)[1],
                      notam_at_arrival: airport_has_notam(departure_airport.id, plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
                      flight_cost: flight_cost_for_aircraft(aircraft, plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport), plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME),
                      flight_time: Time.diff(
                          plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, arrival_airport, departure_airport),
                          plan[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME
                      )[:diff]
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
  # Description: This returns the aircraft_type for given id, This uses preloaded @aircrafts and does not hit the database
  # @param [Integer] id
  # @return [AircraftType]
  ######################################################################
  def aircraft_type_for_id(id)
    @aircraft_type_id_map ||= {}
    return @aircraft_type_id_map[id] if @aircraft_type_id_map[id].present?
    @aircraft_type_id_map[id] = @aircraft_types.detect{ |aircraft_type| aircraft_type.id == id }
    @aircraft_type_id_map[id]
  end

  ######################################################################
  # Description: This returns the handling_cost_grid for given aircraft_category_id and city_id, This uses preloaded @handling_cost_grids and does not hit the database
  # @param [Integer] aircraft_category_id
  # @param [Integer] city_id
  # @return [HandlingCostGrid]
  ######################################################################
  def handling_for_aircraft_category(aircraft_category_id, city_id)
    @handling_cost_grids.detect{ |handling_cost_grid| handling_cost_grid.aircraft_category_id == aircraft_category_id and handling_cost_grid.city_id == city_id }
  end

  ######################################################################
  # Description: This returns the cost for given aircraft and airport
  # @param [Aircraft] aircraft
  # @param [Airport] airport
  # @return [Float]
  ######################################################################
  def get_handling_cost(aircraft, airport)
    cost = 0.0
    aircraft_type = aircraft_type_for_id(aircraft.aircraft_type_id)
    city_id = airport.city_id
    if aircraft_type.present?
      handling_cost_grid =   handling_for_aircraft_category(aircraft_type.aircraft_category_id, city_id)
      if handling_cost_grid.present?
        cost = handling_cost_grid.cost
      end
    end
    cost
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
    @distance_map["#{departure_airport.id}-#{arrival_airport.id}"] = (@distances.detect{ |distance| distance.from_airport_id == departure_airport.id and distance.to_airport_id == arrival_airport.id }.distance_in_nm rescue MathHelper.to_nm(MathHelper.distance_between_lat_long(departure_airport.latitude, departure_airport.longitude, arrival_airport.latitude, arrival_airport.longitude)))
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
    @flight_time_map["#{aircraft.id}-#{departure_airport.id}-#{arrival_airport.id}"] = ( airport_distance_in_nm(departure_airport, arrival_airport) / cruise_speed(aircraft, departure_airport, arrival_airport)).hours + departure_airport.bais_time_in_minutes.minutes + arrival_airport.bais_time_in_minutes.minutes
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

  ######################################################################
  # Description: Returns whether the airport has watch hour at given time
  # @param [Integer] airport_id
  # @param [DateTime] time
  # @return [Boolean, Float]
  ######################################################################
  # noinspection RubyResolve
  def airport_has_watch_hour(airport_id, time)
    @airport_watch_hour_map ||= {}
    return @airport_watch_hour_map["#{airport_id}-#{time.to_s}"] if @airport_watch_hour_map["#{airport_id}-#{time.to_s}"].present?
    watch_hour = @watch_hours.detect{ |w| w.airport_id == airport_id and ( w.start_at <= time and w.end_at >= time )}
    watch_hour.present? ? ( @airport_watch_hour_map["#{airport_id}-#{time.to_s}"] = [ true, watch_hour.cost ] ) : ( @airport_watch_hour_map["#{airport_id}-#{time.to_s}"] = [ false, 0 ] )
    @airport_watch_hour_map["#{airport_id}-#{time.to_s}"]
  end

  ######################################################################
  # Description: Returns whether the airport has any notam in given time
  # @param [Integer] airport_id
  # @param [DateTime] time
  # @return [Boolean]
  ######################################################################
  # noinspection RubyResolve
  def airport_has_notam(airport_id, time)
    @airport_notam_map ||= {}
    return @airport_notam_map["#{airport_id}-#{time.to_s}"] if @airport_notam_map["#{airport_id}-#{time.to_s}"].present?
    notam = @notams.detect{ |n| n.airport_id == airport_id and ( n.start_at <= time and n.end_at >= time ) }
    notam.present? ? ( @airport_notam_map["#{airport_id}-#{time.to_s}"] = true ) : ( @airport_notam_map["#{airport_id}-#{time.to_s}"] = false )
    @airport_notam_map["#{airport_id}-#{time.to_s}"]
  end

  ######################################################################
  # Description: It returns the flight cost for aircraft with given start time and end time
  # @param [Aircraft] aircraft
  # @param [DateTime] start_at
  # @param [DateTime] end_at
  # @return [Float]
  ######################################################################
  def flight_cost_for_aircraft(aircraft, start_at, end_at)
    h = hour_diff(start_at, end_at)
    m = min_diff(start_at, end_at)
    aircraft.per_hour_cost.to_f / 60 * ( h*60 + m )
  end

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

  def check_aircraft_unavailability(aircraft, start_at, end_at)
    flag = false
    aircraft_unavailability = @aircraft_unavailabilities.detect{ |aircraft_unavailability|
      aircraft_unavailability.aircraft_id == aircraft.id and
          (aircraft_unavailability.start_at.between?(start_at, end_at) or
          aircraft_unavailability.end_at.between?(start_at, end_at) or
          start_at.between?(aircraft_unavailability.start_at, aircraft_unavailability.end_at) or
          end_at.between?(aircraft_unavailability.start_at, aircraft_unavailability.end_at))
    }

    if aircraft_unavailability.present?
      flag =  true
    end

    flag

    # @aircraft_unavailabilities.where(
    #     aircraft_id: aircraft.id,
    # ).where(
    #     'start_at BETWEEN ? AND ?
    #      OR
    #      end_at BETWEEN ? AND ?
    #      OR
    #      ? BETWEEN start_at AND end_at
    #      OR
    #      ? BETWEEN start_at AND end_at', @start_time_for_unavailability, @end_time_for_unavailability, @start_time_for_unavailability, @end_time_for_unavailability, @start_time_for_unavailability, @end_time_for_unavailability
    # ).any?

  end

  def aircraft_has_unavailability(aircraft)
    check_aircraft_unavailability(aircraft, @start_time_for_unavailability, @end_time_for_unavailability)
  end

  # def aircraft_has_trip(aircraft)
  #   aircraft.activities.where('start_at BETWEEN ? AND ? OR end_at BETWEEN ? AND ? OR ? BETWEEN start_at AND end_at OR ? BETWEEN start_at AND end_at', @start_time_for_unavailability, @end_time_for_unavailability, @start_time_for_unavailability, @end_time_for_unavailability, @start_time_for_unavailability, @end_time_for_unavailability).any?
  # end

  ######################################################################
  # Description: It returns true if aircraft flying range is more then
  #              or equal to total distance for each activities, else it returns false
  # @param [Aircraft] aircraft
  # @return [boolean]
  ######################################################################
  def aircraft_has_flying_range(aircraft)
    # @total_distance = 0.0
    # @search_activities.each do |f|
    #   @total_distance += Distance.where(from_airport_id: f.departure_airport_id, to_airport_id: f.arrival_airport_id ).first.distance_in_nm
    # end
    # @total_distance >= aircraft.flying_range_in_nm
    # false
    @can_fly = true
    @search_activities.each do |f|
      # return @can_fly = false unless aircraft.flying_range_in_nm >= Distance.where(from_airport_id: f.departure_airport_id, to_airport_id: f.arrival_airport_id ).first.distance_in_nm
      return @can_fly = false unless aircraft.flying_range_in_nm >= airport_distance_in_nm(airport_for_id(f.departure_airport_id), airport_for_id(f.arrival_airport_id))
    end
    @can_fly

  end

  def cruise_speed(aircraft, departure_airport, arrival_airport)
    speed = 0.0
    distance = airport_distance_in_nm(departure_airport, arrival_airport)
    if 0 < distance and distance <= 250
      speed = aircraft.cruise_speed_in_nm_per_hour * 0.8
    else
      speed = aircraft.cruise_speed_in_nm_per_hour
    end
    speed
  end

  # def airport_notam_detail(airport_id, time)
  #   @airport_notam_map ||= {}
  #   return @airport_notam_map["#{airport_id}-#{time.to_s}"] if @airport_notam_map["#{airport_id}-#{time.to_s}"].present?
  #   notam = @notams.detect{ |n| n.airport_id == airport_id and ( n.start_at <= time and n.end_at >= time ) }
  #   notam.present? ? ( @airport_notam_map["#{airport_id}-#{time.to_s}"] = true ) : ( @airport_notam_map["#{airport_id}-#{time.to_s}"] = false )
  #   @airport_notam_map["#{airport_id}-#{time.to_s}"]
  # end


  def make_search_description(airport_ids, dates)

    search = []
    # watch_hour = nil
    # notam = nil

    for id in airport_ids

      airport = @airports.detect{ |a| a if a.id == id }
      x = {
          name: '',
          night_landing: false,
          night_parking: false,
          is_watch_hour: false,
          is_notam: false,
          watch_hour: [],
          notam: []
      }
      x[:name] = airport.city.name
      x[:night_landing] = airport.night_landing
      x[:night_parking] = airport.night_parking

      for date in dates
        watch_hour = nil
        notam = nil

        watch_hour =  @watch_hours.detect{ |w| w.airport_id == id and ( w.start_at <= date.end_of_day and w.end_at >= date.beginning_of_day ) }

        if watch_hour.present?
          x[:is_watch_hour] = true
          x[:watch_hour] << watch_hour
        end

        # date = date.to_datetime

        notam = @notams.detect{ |n|
          (n.airport_id == id and ( n.start_at <= date.end_of_day and n.end_at >= date.beginning_of_day ))
        }

        if notam.present?
          x[:is_notam] = true
          x[:notam] << notam
        end
      end
      # Date.today.between?(Date.yesterday, Date.tomorrow)

      search << x

    end

    search

    # dates.first.beginning_of_day
    # dates.first.end_of_day

  end

  def check_airport_availablity(search_activities)
    details = {}

    airport_ids = search_activities.map(&:departure_airport_id) + search_activities.map(&:arrival_airport_id)
    airport_ids = airport_ids.uniq
    dates = search_activities.map(&:start_at)

    details = make_search_description(airport_ids, dates)

    details

    # ==============================

    #
    # notam_detail = []
    #
    # watch_hour_detail = []
    #
    # details = {}
    #
    # search_activities.each do |activity|
    #   expected_time = activity.start_at
    #
    #   if airport_has_notam(activity.departure_airport_id, expected_time)
    #     notam_detail << {
    #         airport:  @airports.detect{|x| x.id == activity.departure_airport_id },
    #         start_at:  @notams.detect{ |n| n.airport_id == activity.departure_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.start_at,
    #         end_at:  @notams.detect{ |n| n.airport_id == activity.departure_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.end_at
    #     }
    #   end
    #
    #   if airport_has_notam(activity.arrival_airport_id, expected_time)
    #     notam_detail << {
    #         airport:  @airports.detect{|x| x.id == activity.arrival_airport_id },
    #         start_at:  @notams.detect{ |n| n.airport_id == activity.arrival_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.start_at,
    #         end_at:  @notams.detect{ |n| n.airport_id == activity.arrival_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.end_at
    #     }
    #   end
    #
    #   if airport_has_watch_hour(activity.departure_airport_id, expected_time).first
    #     watch_hour_detail << {
    #         airport:  @airports.detect{|x| x.id == activity.departure_airport_id },
    #         start_at:  @watch_hours.detect{ |n| n.airport_id == activity.departure_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.start_at,
    #         end_at:  @watch_hours.detect{ |n| n.airport_id == activity.departure_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.end_at
    #     }
    #   end
    #
    #   if airport_has_watch_hour(activity.arrival_airport_id, expected_time).first
    #     watch_hour_detail << {
    #         airport:  @airports.detect{|x| x.id == activity.arrival_airport_id },
    #         start_at:  @watch_hours.detect{ |n| n.airport_id == activity.arrival_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.start_at,
    #         end_at:  @watch_hours.detect{ |n| n.airport_id == activity.arrival_airport_id and ( n.start_at <= expected_time and n.end_at >= expected_time ) }.end_at
    #     }
    #   end
    #
    # end
    #
    #
    # details  = {
    #     notam_details: notam_detail,
    #     watch_hour_details: watch_hour_detail
    # }

  end


  def airport_max_field_for_landing(search_activities)
    airport_ids = search_activities.map(&:departure_airport_id) + search_activities.map(&:arrival_airport_id)

    # Airport.where(id: airport_ids).map(&:runway_field_length_in_feet).min
    Airport.where(id: airport_ids).minimum(:runway_field_length_in_feet)
  end

  # def flight_in_night(time)
  #   time
  # end
  #
  # def aircraft_has_night_landing?(aircraft)
  #   # aircraft
  #   # activity_time_list = []
  #
  #   @search_activities.each do |search_activity|
  #     return true if flight_in_night(search_activity.start_at)
  #     return false if flight_in_night(search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)))
  #   end
  #
  #   # @search_activities.first.start_at + flight_time_in_hours(aircraft, airport_for_id(@search_activities.first.departure_airport_id), airport_for_id(@search_activities.first.arrival_airport_id))
  #   # search_activity.start_at + flight_time_in_hours(aircraft, airport_for_id(search_activity.departure_airport_id), airport_for_id(search_activity.arrival_airport_id)),
  # end

  def is_overriding_activities(aircraft)
    last_result = @results.last
    date_list = []
    is_override_activity = false

    for plan in last_result[:flight_plan]

      start_at = plan[:start_at]
      end_at = plan[:end_at]
      if plan[:accommodation_leg].present?
        nights = plan[:accommodation_leg][:nights]
        end_at = plan[:end_at] + nights.days
      end

      date_list << {
          start_at: start_at,
          end_at: end_at
      }
    end

    for plan_time in date_list
      # activities.start_at BETWEEN ? AND ?
      # OR activities.end_at BETWEEN ? AND ?
      # OR ? BETWEEN activities.start_at AND activities.end_at
      # OR ? BETWEEN activities.start_at AND activities.end_at
      x = @activities.detect{ |a|
        a.aircraft_id == aircraft.id and (a.start_at.between?(plan_time[:start_at], plan_time[:end_at]) or a.end_at.between?(plan_time[:start_at], plan_time[:end_at]) or plan_time[:start_at].between?(a.start_at, a.end_at) or plan_time[:end_at].between?(a.start_at, a.end_at))
      }.present?
      is_override_activity = true if x
    end
    @results.pop if is_override_activity

  end

  def calculate_empty_leg_plan_cost(aircraft, previous_leg, search_activity)
    landing_cost_at_base = base_airport(aircraft).landing_cost
    handling_cost_at_base = get_handling_cost(aircraft, base_airport(aircraft))

    flight_cost_for_base =  flight_cost_for_aircraft(aircraft,
                                                    previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME,
                                                    previous_leg.last[:end_at] + CONTINUOUS_FLIGHT_DELTA_TIME + flight_time_in_hours(aircraft, airport_for_id(previous_leg.last[:arrival_airport_id]), base_airport(aircraft)))


    landing_cost_at_user_departure = search_activity.departure_airport.landing_cost
    handling_cost_at_user_arrival = get_handling_cost(aircraft, search_activity.arrival_airport)
    flight_cost_for_activity = flight_cost_for_aircraft(aircraft,
                             previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME - flight_time_in_hours(aircraft, search_activity.departure_airport,  airport_for_id(previous_leg.last[:arrival_airport_id])),
                             previous_leg.last[:start_at] - CONTINUOUS_FLIGHT_DELTA_TIME)

    cost = landing_cost_at_base + handling_cost_at_base + flight_cost_for_base + landing_cost_at_user_departure + handling_cost_at_user_arrival + flight_cost_for_activity

    cost
  end

end