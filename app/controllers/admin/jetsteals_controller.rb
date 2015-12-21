class Admin::JetstealsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jetsteal, only: [:update, :edit]

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
    JetstealSeatsBuilder.new(@jetsteal).build_seats unless @jetsteal.jetsteal_seats.any?
  end

  def update
    if @jetsteal.update_attributes(update_jetsteal_params)
      flash[:success] = 'Jetsteal successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def jetsteal_params
    params.require(:jetsteal).permit(
                                 :departure_airport_id,
                                 :arrival_airport_id,
                                 :aircraft_id,
                                 :sell_by_seats,
                                 :start_at,
                                 :end_at,
                                 :cost
    )
  end

  def update_jetsteal_params
    params.require(:jetsteal).permit(
        jetsteal_seats_attributes: [
            :id,
            :ui_seat_id,
            :disabled,
            :cost
        ]
    )
  end

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:id]
  end

end