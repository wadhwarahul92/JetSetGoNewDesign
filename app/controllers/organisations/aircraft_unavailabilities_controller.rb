class Organisations::AircraftUnavailabilitiesController < Organisations::BaseController

  before_action :authenticate_operator

  def index
    if request.format == 'application/json'
      @aircraft_unavailabilities = AircraftUnavailability.where(aircraft_id: current_organisation.aircrafts.map(&:id))
    end
  end

  def new

  end

  def create
    @aircraft_unavailability = AircraftUnavailability.new(aircraft_unavailability_params)
    if @aircraft_unavailability.valid? and org_owns_aircraft_with_id?(params[:aircraft_id]) and @aircraft_unavailability.save
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @aircraft_unavailability.errors.full_messages }
    end
  end

  private

  def aircraft_unavailability_params
    params.permit(
              :aircraft_id,
              :start_at,
              :end_at,
              :reason
    )
  end

  def org_owns_aircraft_with_id?(id)
    aircraft = Aircraft.where(id: id).first
    aircraft.present? and aircraft.organisation_id == current_organisation.id
  end

end