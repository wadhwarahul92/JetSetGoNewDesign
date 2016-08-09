class Admin::HandlingCostGridsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @handling_cost_grids = HandlingCostGrid.all
  end

  def new
    @handling_cost_grid = HandlingCostGrid.new
  end

  def create
    @handling_cost_grid = HandlingCostGrid.new(handling_cost_grid_params)
    if @handling_cost_grid.save
      flash[:success] = 'Handling cost grid created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit
    @handling_cost_grid = HandlingCostGrid.find params[:id]
  end

  def update
    @handling_cost_grid = HandlingCostGrid.find params[:id]
    if @handling_cost_grid.update_attributes(handling_cost_grid_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def handling_cost_grid_params
    params.require(:handling_cost_grid).permit(
        # :airport_id,
        # :aircraft_id,
        :city_id,
        :aircraft_category_id,
        :cost
    )
  end

end