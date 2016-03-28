# noinspection RubyResolve
class Organisations::TripsController < Organisations::BaseController

  before_action :authenticate_operator

  def index
    if request.format == 'application/json'
      if params[:start_at].present? and params[:end_at].present?
        start_at = DateTime.parse(params[:start_at])
        end_at = DateTime.parse(params[:end_at])
        aircraft_ids = current_organisation.aircrafts.map(&:id)
        @activities = Activity.joins(
            'LEFT OUTER JOIN trips ON activities.trip_id = trips.id'
        ).where(
            'trips.status = ?', Trip::STATUS_CONFIRMED
        ).where(aircraft_id: aircraft_ids).where('activities.start_at BETWEEN ? AND ?', start_at, end_at)
      end
    end
  end

  def new
    render layout: false
  end

  def show
    @activity = Activity.find params[:id]
  end

  def destroy_trip
    @trip = Trip.find params[:id]
    @trip.destroy
    render status: :ok, nothing: true
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

      @enquiries = Trip.where(
          organisation_id: current_organisation.id
      ).where(status: Trip::STATUS_ENQUIRY).includes(:activities)

      @quotes = Trip.where(
          organisation_id: current_organisation.id
      ).where(status: Trip::STATUS_QUOTED)

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

        @enquiries = @enquiries.joins(
            'JOIN activities ON trips.id = activities.trip_id'
        ).where(
            'activities.start_at BETWEEN ? AND ?', start_at, end_at
        ).distinct

        @quotes = @quotes.joins(
            'JOIN activities ON trips.id = activities.trip_id'
        ).where(
             'activities.start_at BETWEEN ? AND ?', start_at, end_at
        ).distinct

      end

    end
  end

  def create
    begin
      TripCreator.new(params[:aircraft_id], activities_params, current_organisation).create!
      render status: :ok, nothing: true
    rescue Exception => e
      render status: :unprocessable_entity, json: { errors: [e.message] }
    end
  end

  def get_enquiry
    @trip = current_organisation.trips.find(params[:id])
    if @trip.status == Trip::STATUS_ENQUIRY
      render status: :ok
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  def get_empty_legs
    if request.format == 'application/json'
      @empty_legs = current_organisation.trips.joins(
          'JOIN activities ON trips.id = activities.trip_id'
      ).where(
           'activities.empty_leg IS TRUE'
      ).distinct
    end
  end

  def get_enquiries
    if request.format == 'application/json'
      @enquiries = current_organisation.trips.includes(:activities).where(status: Trip::STATUS_ENQUIRY)
    end
  end

  def get_quote
    @trip = current_organisation.trips.find(params[:id])
    if @trip.status == Trip::STATUS_QUOTED
      render status: :ok
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  def send_quote
    send_quote_service = SendQuoteService.new(params[:enquiry])
    begin
      send_quote_service.process!
      render status: :ok, nothing: true
    rescue Exception => e
      render status: :unprocessable_entity, json: { errors: [e.message] }
    end
  end

  def get_trip
    @trip = current_organisation.trips.find params[:id]
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
