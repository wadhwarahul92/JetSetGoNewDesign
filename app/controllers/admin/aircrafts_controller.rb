class Admin::AircraftsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft, only: [:show]

  def index
    @aircrafts = Aircraft.includes(:aircraft_type).all
  end

  def new
    @aircraft = Aircraft.new
  end

  def show

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
                                 :memorable_name
    )
  end

  def set_aircraft
    @aircraft = Aircraft.find params[:id]
  end

end