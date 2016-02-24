class Organisations::TripsController < Organisations::BaseController

  before_action :authenticate_operator

  def index
    if request.format == 'application/json'
      if params[:start_at].present? and params[:end_at].present?
        start_at = DateTime.parse(params[:start_at])
        end_at = DateTime.parse(params[:end_at])
        aircraft_ids = current_organisation.aircrafts.map(&:id)
        @activities = Activity.where(aircraft_id: aircraft_ids).where('start_at BETWEEN ? AND ?', start_at, end_at)
      end
    end
  end

  def new

  end

  def show
    @activity = Activity.find params[:id]
  end

  def destroy
    @activity = Activity.find params[:id]
    @activity.destroy
    render status: :ok, nothing: true
  end

  # noinspection RailsChecklist01
  def all_events
    if request.format == 'application/json'
      if params[:start_at].present? and params[:end_at].present?
        start_at = DateTime.parse(params[:start_at])
        end_at = DateTime.parse(params[:end_at])
        aircraft_ids = current_organisation.aircrafts.map(&:id)
        @activities = Activity.where(aircraft_id: aircraft_ids).where(
            'start_at BETWEEN ? AND ?', start_at, end_at
        )
        @aircraft_unavailabilities = AircraftUnavailability.where(aircraft_id: aircraft_ids).where(
            'start_at BETWEEN ? AND ?', start_at, end_at
        )
      end
    end
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