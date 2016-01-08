class Admin::AirportsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @airports = Airport.includes(:city).all
  end

  def new
    @airport = Airport.new
  end

  def create
    @airport = Airport.new(airport_params)
    if @airport.save
      flash[:success] = 'Airport created successfully.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def airport_params
    params.require(:airport).permit(
                                :name,
                                :city_id,
                                :Longitude,
                                :latitude
    )
  end

end