class Admin::DistancesController < Admin::BaseController
  before_filter :authenticate_admin
  before_filter :set_distance ,only: [:edit, :update]

  def index

    if params[:from_airport_id].present?
      @distances = Distance.where('lower(from_airport_id) LIKE ? ', "%#{params[:from_airport_id].to_s.downcase}%").paginate(page: params[:page], per_page: 50)
    else
      @distances = Distance.paginate(page: params[:page], per_page: 50)
    end
  end

  def new
    @distance = Distance.new
  end

  def edit

  end

  def update
    if @distance.update_attributes(distance_params)
      flash[:success] = 'Distance successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
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
        :distance_in_nm
    )
  end

  def set_distance
    @distance = Distance.find params[:id]
  end
end