# noinspection RubyResolve
class Organisations::TripsController < Organisations::BaseController

  before_action :authenticate_operator

  def update
    @trip = current_organisation.trips.find params[:id]
    @trip.update_attributes!(params[:trip].permit!)
    redirect_to(params[:redirect_url] || '/')
  end

  def confirmed
    @trips = current_organisation.trips.where(status: Trip::STATUS_CONFIRMED)
  end

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
    AdminMailer.delete_enquiry(current_user, @trip).deliver_later
    # OrganisationMailer.delete_enquiry(current_user, @trip).deliver_later
    render status: :ok, nothing: true
  end

  def destroy
    @activity = Activity.find params[:id]
    @activity.destroy
    AdminMailer.delete_single_trip(current_user, @activity).deliver_later
    # OrganisationMailer.delete_single_trip(current_user, @activity).deliver_later
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
      trip_creator = TripCreator.new(params[:aircraft_id], activities_params, current_organisation)
      if trip_creator.create!
        AdminMailer.operator_adds_new_trip(current_user, trip_creator.trip).deliver_later
        # OrganisationMailer.new_trip(current_user, trip_creator.trip).deliver_later

        # current_organisation.operators.each do |operator|
        #   NotificationService.trip_added(operator, trip_creator.trip).deliver_later
        # end
        render status: :ok, json: { trip_id: trip_creator.trip.id }
      end
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
      @empty_legs = current_organisation.trips.where(status: Trip::STATUS_CONFIRMED).joins(
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
      AdminMailer.send_quote(current_user, send_quote_service.trip).deliver_later
      # OrganisationMailer.send_quote(current_user, send_quote_service.trip).deliver_later
      # CustomerMailer.send_quote(send_quote_service.trip.user, send_quote_service.trip.user).deliver_later
      # send_quote_service.trip.organisation.operators.each do |operator|
      #   NotificationService.quote_created(operator, send_quote_service.trip).deliver_later
      # end
      # CustomerNotificationService.quote_created(send_quote_service.trip.user, send_quote_service.trip).deliver_later
      # SmsDelivery.new(send_quote_service.trip.user.phone.to_s, SmsTemplates.generate_quote).delay.deliver

      render status: :ok, nothing: true
    rescue Exception => e
      render status: :unprocessable_entity, json: { errors: [e.message] }
    end
  end

  def get_trip
    @trip = current_organisation.trips.find params[:id]
  end

  def get_trips
    @trips = current_organisation.trips
  end

  def get_activities

    if params[:start_at].present? and params[:end_at].present?
      start_at = DateTime.parse(params[:start_at])
      end_at = DateTime.parse(params[:end_at])
    else
      start_at = DateTime.now - 1.month
      end_at = DateTime.now + 1.month
    end

    trip_ids = Activity.joins(
        'left outer JOIN trips on activities.trip_id = trips.id'
    ).where(
        'trips.organisation_id = ?', current_organisation.id
    ).where(
        'trips.status = ?', Trip::STATUS_CONFIRMED
    ).where(
        'activities.start_at BETWEEN ? AND ? or activities.end_at BETWEEN ? AND ? or ? between activities.start_at and activities.end_at or ? between activities.start_at and activities.end_at', start_at, end_at, start_at, end_at, start_at, end_at
    ).distinct.map(&:trip_id)

    @trips = Trip.where(id: trip_ids)

    @empty_legs = Activity.joins(
        'left outer JOIN trips on activities.trip_id = trips.id'
    ).where(
        'trips.organisation_id = ?', current_organisation.id
    ).where(
        'trips.status = ?', Trip::STATUS_CONFIRMED
    ).where(
        'activities.start_at BETWEEN ? AND ? or activities.end_at BETWEEN ? AND ? or ? between activities.start_at and activities.end_at or ? between activities.start_at and activities.end_at', start_at, end_at, start_at, end_at, start_at, end_at
    ).where(
        'activities.empty_leg is true'
    ).distinct

    enquiry_ids = Activity.joins(
        'left outer JOIN trips on activities.trip_id = trips.id'
    ).where(
        'trips.organisation_id = ?', current_organisation.id
    ).where(
        'trips.status = ?', Trip::STATUS_ENQUIRY
    ).where(
        'activities.start_at BETWEEN ? AND ? or activities.end_at BETWEEN ? AND ? or ? between activities.start_at and activities.end_at or ? between activities.start_at and activities.end_at', start_at, end_at, start_at, end_at, start_at, end_at
    ).distinct.map(&:trip_id)

    @enquiries = Trip.where(id: enquiry_ids)

    quote_ids = Activity.joins(
        'left outer JOIN trips on activities.trip_id = trips.id'
    ).where(
        'trips.organisation_id = ?', current_organisation.id
    ).where(
        'trips.status = ?', Trip::STATUS_QUOTED
    ).where(
        'activities.start_at BETWEEN ? AND ? or activities.end_at BETWEEN ? AND ? or ? between activities.start_at and activities.end_at or ? between activities.start_at and activities.end_at', start_at, end_at, start_at, end_at, start_at, end_at
    ).distinct.map(&:trip_id)

    @quotes = Trip.where(id: quote_ids)

    @aircraft_unavailabilities = AircraftUnavailability.joins(
        'left outer join aircrafts on aircraft_unavailabilities.aircraft_id = aircrafts.id'
    ).where(
        'aircrafts.organisation_id = ?', current_organisation.id
    ).where(
        'aircraft_unavailabilities.start_at BETWEEN ? AND ? or aircraft_unavailabilities.end_at Between ? AND ? or ? between aircraft_unavailabilities.start_at and aircraft_unavailabilities.end_at or ? between aircraft_unavailabilities.start_at and aircraft_unavailabilities.end_at', start_at, end_at, start_at, end_at, start_at, end_at
    ).distinct

  end

  def feature_for_sale
    @activity = Activity.where(trip_id: params[:id]).first
    if @activity.update_attributes(empty_leg_whole_price: params[:empty_leg_whole_price], empty_leg_seat_price: params[:empty_leg_seat_price])
      render status: :ok ,nothing: true
    else
      render status: :unprocessable_entity, json: { error: messages.first }
    end


  end

  private

  def activities_params
    params.permit(activities: [
                      :departure_airport_id,
                      :arrival_airport_id,
                      :start_at,
                      :empty_leg,
                      :pax,
                      :empty_leg_whole_price,
                      :empty_leg_seat_price
                  ])
  end



end
