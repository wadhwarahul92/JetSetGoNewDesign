class Admin::AircraftsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft, only: [:show, :edit, :update]

  def index
    @aircrafts = Aircraft.includes(:aircraft_type).all
  end

  def new
    @aircraft = Aircraft.new
  end

  def show

  end

  def edit

  end

  def update
    if @aircraft.update_attributes(aircraft_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def create
    @aircraft = Aircraft.new(aircraft_params)
    if @aircraft.save
      flash[:success] = 'Aircraft successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def aircraft_params
    params.require(:aircraft).permit(
                                 :tail_number,
                                 :aircraft_type_id,
                                 :seating_capacity,
                                 :baggage_capacity_in_kg,
                                 :landing_field_length_in_feet,
                                 :runway_field_length_in_feet,
                                 :number_of_toilets,
                                 :cabin_width_in_meters,
                                 :cabin_height_in_meters,
                                 :cabin_length_in_meters,
                                 :memorable_name,
                                 :crew,
                                 :wifi,
                                 :phone,
                                 :flight_attendant,
                                 :cruise_speed_in_nm_per_hour,
                                 :flying_range_in_nm,
                                 :per_hour_cost,
                                 :catering_cost_per_pax,
                                 :organisation_id,
                                 :year_of_manufacture,
                                 :medical_evac
    )
  end

  def set_aircraft
    @aircraft = Aircraft.find params[:id]
  end

end