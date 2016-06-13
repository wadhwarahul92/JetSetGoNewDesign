class Admin::AirportCategoriesController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_airport_category, only: [:edit, :update]

  def index
    @airport_categories = AirportCategory.all
  end

  def new
    @airport_category = AirportCategory.new
  end

  def create
    @airport_category = AirportCategory.new(airport_category_params)
    if @airport_category.save
      flash[:success] = 'Airport category created successfully.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @airport_category.update_attributes(airport_category_params)
      flash[:success] = 'Airport category successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def airport_category_params
    params.require(:airport_category).permit(:name)
  end

  def set_airport_category
    @airport_category = AirportCategory.find params[:id]
  end

end