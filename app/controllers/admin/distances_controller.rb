class Admin::DistancesController < Admin::BaseController
  before_filter :authenticate_admin

  def index
    @distances = Distance.all
  end

  def new
    @distance = Distance.new
  end

  def create
    @distance = Distance.new(distance_params)
    if @distance.save
      flash[:success] = 'Distance created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def distance_params
    params.require(:distance).permit(
        :from_airport_id,
        :to_airport_id,
        :distance
    )
  end
end