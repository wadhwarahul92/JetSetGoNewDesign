class Admin::AircraftCategoriesController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft_category, only: [:edit, :update]

  def index
    @aircraft_categories = AircraftCategory.all
  end

  def new
    @aircraft_category = AircraftCategory.new
  end

  def create
    @aircraft_category = AircraftCategory.new(aircraft_category_params)
    if @aircraft_category.save
      flash[:success] = 'Aircraft category successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @aircraft_category.update_attributes(aircraft_category_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def aircraft_category_params
    params.require(:aircraft_category).permit(:name)

  end

  def set_aircraft_category
    @aircraft_category = AircraftCategory.find params[:id]
  end

end