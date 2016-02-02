class Admin::AirportsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_airport, only: [:edit, :update]

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

  def edit

  end

  def update
    if @airport.update_attributes(airport_params)
      flash[:success] = 'Airport successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def airport_params
    params.require(:airport).permit(
                                :name,
                                :city_id,
                                :longitude,
                                :latitude,
                                :code
    )
  end

  def set_airport
    @airport = Airport.find params[:id]
  end

end