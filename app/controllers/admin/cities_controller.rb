class Admin::CitiesController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @cities = City.all
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    if @city.save
      flash[:success] = 'City created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def city_params
    params.require(:city).permit(
        :name,
        :state
    )
  end

end