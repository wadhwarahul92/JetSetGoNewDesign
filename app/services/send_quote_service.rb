class SendQuoteService

  def initialize(params)
    @params = params
  end

  def process!
    find_trip
    Trip.transaction do
      update_trip
      update_activities
    end
  end

  private

  def find_trip
    @trip ||= Trip.find @params[:id]
  end

  def update_trip
    @trip.update_attributes!(status: Trip::STATUS_QUOTED)
  end

  def update_activities
    @params[:activities].each do |activity_params|
      activity = Activity.find activity_params[:id]
      to_update = {
          flight_cost: activity_params[:flight_cost],
          handling_cost_at_takeoff: activity_params[:handling_cost_at_takeoff],
          landing_cost_at_arrival: activity_params[:landing_cost_at_arrival],
          watch_hour_cost: activity_params[:watch_hour_cost]
      }
      if activity_params[:accommodation_plan].present?
        to_update[:accommodation_plan] = {
            cost: activity_params[:accommodation_plan][:cost],
            nights: activity_params[:accommodation_plan][:nights]
        }
      end
      activity.update_attributes!(to_update)
    end
  end

end