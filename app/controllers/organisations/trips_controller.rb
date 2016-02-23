class Organisations::TripsController < Organisations::BaseController

  before_action :authenticate_operator

  def index

  end

  def new

  end

  def create
    TripCreator.new(params[:aircraft_id], activities_params, current_organisation).create!
  end

  private

  def activities_params
    params.permit(activities: [
        :departure_airport_id,
        :arrival_airport_id,
        :start_at,
        :empty_leg,
        :pax
    ])
  end

end