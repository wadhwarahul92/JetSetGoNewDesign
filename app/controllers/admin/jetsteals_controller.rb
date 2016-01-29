class Admin::JetstealsController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_jetsteal, only: [:update, :edit, :launch]

  before_action :check_if_launched, only: [:edit, :update]

  before_action :build_jetsteal_seats, only: [:edit, :launch]

  def index
    @jetsteals = Jetsteal.includes(:departure_airport).includes(:arrival_airport).includes(:aircraft).order('created_at DESC')
  end

  def new
    @jetsteal = Jetsteal.new
  end

  def create
    @jetsteal = Jetsteal.new(jetsteal_params)
    if @jetsteal.save
      flash[:success] = 'Jetsteal created successfully'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @jetsteal.update_attributes(update_jetsteal_params)
      flash[:success] = 'Jetsteal successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def launch
    jetsteal_launcher = JetstealLauncher.new(@jetsteal)
    if jetsteal_launcher.launch!
      flash[:success] = "Jetsteal ##{@jetsteal.id} launched"
      redirect_to action: :index
    else
      flash[:error] = jetsteal_launcher.error_message
      redirect_to action: :index
    end
  end

  private

  def build_jetsteal_seats
    JetstealSeatsBuilder.new(@jetsteal).build_seats unless @jetsteal.jetsteal_seats.any?
  end

  def jetsteal_params
    params.require(:jetsteal).permit(
                                 :departure_airport_id,
                                 :arrival_airport_id,
                                 :aircraft_id,
                                 :sell_by_seats,
                                 :start_at,
                                 :end_at,
                                 :flight_duration_in_minutes,
                                 :cost
    )
  end

  def update_jetsteal_params
    params.require(:jetsteal).permit(
        jetsteal_seats_attributes: [
            :id,
            :ui_seat_id,
            :disabled,
            :cost,
            :orientation,
            :seat_type
        ]
    )
  end

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:id]
  end

  def check_if_launched
    if @jetsteal.launched?
      flash[:error] = 'This jetsteal is launched, it cannot be updated now.'
      redirect_to action: :index
    end
  end

end