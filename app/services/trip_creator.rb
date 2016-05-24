class TripCreator

  attr_accessor :trip

  def initialize(aircraft_id, activities, organisation)
    @aircraft = Aircraft.find(aircraft_id)
    @activities = activities[:activities]
    @aircraft_errors = []
    @organisation = organisation
  end

  def create!
    Trip.transaction do
      @trip = Trip.create!(status: Trip::STATUS_CONFIRMED, organisation_id: @organisation.id)
      @activities.each do |activity|
        # @aircraft.activities.create!(activity.merge(trip_id: @trip.id))
        create_activity(activity.merge(trip_id: @trip.id))
      end
    end
  end

  private

  def validate_aircraft
    @aircraft_errors << 'This aircraft is not approved by site admin' unless @aircraft.admin_verified?
    @aircraft_errors << 'Your organisation is not verified by site admin' unless @aircraft.organisation.admin_verified?
  end

  def create_activity(activity)
    created_activity = @aircraft.activities.create!(activity)
    created_activity.flight_cost = created_activity.aircraft.per_hour_cost * no_of_hours(created_activity.start_at, created_activity.end_at)
    created_activity.handling_cost_at_takeoff = created_activity.departure_airport.handling_cost
    created_activity.landing_cost_at_arrival = created_activity.departure_airport.landing_cost
    w = WatchHour.where(
        airport_id: created_activity.arrival_airport_id
    ).where(
        '? BETWEEN start_at AND end_at', created_activity.end_at
    ).last
    if w.present?
      created_activity.watch_hour_cost = w.cost
      created_activity.watch_hour_at_arrival = true
    else
      created_activity.watch_hour_cost = 0
      created_activity.watch_hour_at_arrival = false
    end

    created_activity.save
  end

  def no_of_hours(start_time, end_time)
    TimeDifference.between(start_time,end_time).in_hours.to_f
  end

end