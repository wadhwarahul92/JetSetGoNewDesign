class Admin::AircraftTypesController < Admin::BaseController

  after_filter :authenticate_admin

  before_filter :set_aircraft_type, only: [:edit, :update]

  def index
    @aircraft_types = AircraftType.all
  end

  def new
    @aircraft_type = AircraftType.new
  end

  def create
    @aircraft_type = AircraftType.new(aircraft_type_params)
    if @aircraft_type.save
      flash[:success] = 'Aircraft type successfully created'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @aircraft_type.update_attributes(aircraft_type_params)
      flash[:success] = 'Aircraft type successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def aircraft_type_params
    params.require(:aircraft_type).permit(
                                      :name,
                                      :svg,
                                      :speed_in_kts
    )
  end

  def set_aircraft_type
    @aircraft_type = AircraftType.find params[:id]
  end

end