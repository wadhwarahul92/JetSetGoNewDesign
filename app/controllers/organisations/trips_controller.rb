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
    #only respond to JSON
    if request.format == 'application/json'

      aircraft_ids = current_organisation.aircrafts.map(&:id)

      @activities = Activity.includes(:trip).joins(
          'LEFT OUTER JOIN trips ON activities.trip_id = trips.id'
      ).where(
           'trips.status = ?', Trip::STATUS_CONFIRMED
      ).includes(:aircraft).where(aircraft_id: aircraft_ids)

      @aircraft_unavailabilities = AircraftUnavailability.includes(:aircraft).where(aircraft_id: aircraft_ids)

      if params[:start_at].present? and params[:end_at].present?

        start_at = DateTime.parse(params[:start_at])
        end_at = DateTime.parse(params[:end_at])

        @activities = @activities.where(
            'start_at BETWEEN ? AND ?', start_at, end_at
        )
        @aircraft_unavailabilities = @aircraft_unavailabilities.where(
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