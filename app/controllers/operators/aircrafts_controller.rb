class Operators::AircraftsController < Operators::BaseController	

  def index
    
  end

  def new

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
end