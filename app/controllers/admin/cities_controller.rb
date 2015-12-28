class Admin::CitiesController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @cities = City.paginate(page: params[:page], per_page: 20)
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

  def edit
    @city = City.find params[:id]
  end

  def update
    @city = City.find params[:id]
    if @city.update_attributes(city_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def city_params
    params.require(:city).permit(
        :name,
        :state,
        :image
    )
  end

end