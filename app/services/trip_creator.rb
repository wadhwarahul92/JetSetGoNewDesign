class TripCreator

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
        @aircraft.activities.create!(activity)
      end
    end
  end

  private

  def validate_aircraft
    @aircraft_errors << 'This aircraft is not approved by site admin' unless @aircraft.admin_verified?
    @aircraft_errors << 'Your organisation is not verified by site admin' unless @aircraft.organisation.admin_verified?
  end

end