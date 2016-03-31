class Organisations::AircraftUnavailabilitiesController < Organisations::BaseController

  before_action :authenticate_operator

  def index
    if request.format == 'application/json'
      @aircraft_unavailabilities = AircraftUnavailability.where(aircraft_id: current_organisation.aircrafts.map(&:id))
    end
  end

  def new
    render layout: false
  end

  def create
    @aircraft_unavailability = AircraftUnavailability.new(aircraft_unavailability_params)
    if @aircraft_unavailability.valid? and org_owns_aircraft_with_id?(params[:aircraft_id]) and @aircraft_unavailability.save
      AdminMailer.operator_added_unavailability(current_user, @aircraft_unavailability).deliver_later
      OrganisationMailer.new_aircraft_unavailability(current_user, @aircraft_unavailability).deliver_later

      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @aircraft_unavailability.errors.full_messages }
    end
  end

  def show
    @aircraft_unavailability = AircraftUnavailability.find params[:id]
  end

  def update
    @aircraft_unavailability = AircraftUnavailability.find params[:id]
    if @aircraft_unavailability.update_attributes(aircraft_unavailability_params)
      render status: :ok
    else
      render status: :unprocessable_entity, json: { errors: @aircraft_unavailability.errors.full_messages }
    end
  end

  def destroy
    @aircraft_unavailability = AircraftUnavailability.find params[:id]
    if @aircraft_unavailability.destroy
      AdminMailer.delete_aircraft_unavailability(current_user, @aircraft_unavailability).deliver_later
      OrganisationMailer.delete_aircraft_unavailability(current_user, @aircraft_unavailability).deliver_later
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