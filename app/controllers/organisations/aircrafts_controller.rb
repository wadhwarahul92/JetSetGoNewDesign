class Organisations::AircraftsController < Organisations::BaseController

	before_action :authenticate_operator
	
	before_filter :set_aircraft, only: [:edit, :update]	

	def index
		@aircrafts = current_user.organisation.aircrafts.includes(:aircraft_type, :aircraft_images)
  end

	def new
		
	end

	def create
		@aircraft = current_user.organisation.aircrafts.new(aircraft_params)
  	if @aircraft.save
  		render status: :ok, nothing: true
  	else
      render status: :unprocessable_entity, json: { errors: @aircraft.errors.full_messages }
  	end
	end

	def update
    if @aircraft.update_attributes(aircraft_params)
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @aircraft.errors.full_messages }
    end
  end

  def create
  	@aircraft = current_user.aircrafts.new(aircraft_params)
  	if @aircraft.save
  		render status: :ok, nothing: true
  	else
      render status: :unprocessable_entity, json: { errors: @aircraft.errors.full_messages }
  	end
  end

	private

  def aircraft_params
	  params.permit(:tail_number,
	                :aircraft_type_id,
	                :seating_capacity,
	                :runway_field_length_in_feet,
	                :baggage_capacity_in_kg,
	                :number_of_toilets,
	                :cabin_width_in_meters,
	                :cabin_height_in_meters,
	                :crew,
	                :wifi,
	                :year_of_manufacture,
	                :medical_evac,
	                :cruise_speed_in_nm_per_hour,
	                :flying_range_in_nm,
	                :per_hour_cost,
	                :catering_cost_per_pax,
	                :phone,
	                :flight_attendant

	  )
	end

  def set_aircraft
    @aircraft = current_user.organisation.aircrafts.find params[:id]
  end

end