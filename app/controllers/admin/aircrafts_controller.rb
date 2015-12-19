class Admin::AircraftsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @aircrafts = Aircraft.includes(:aircraft_type).all
  end

  def new
    @aircraft = Aircraft.new
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
                                 :aircraft_type_id
    )
  end

end