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
        # create_activity(activity.merge(trip_id: @trip.id))
        @aircraft.activities.create!(activity.merge(trip_id: @trip.id))
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
    # created_activity.flight_cost = #created_activity.aircraft.cost_per_hour * number of hours
    # created_activity.handlingakjdkj = cretaed.departueeairport.handli
    # vosjdjos.lan = cre.arri.landi
    # cret.save
  end

end