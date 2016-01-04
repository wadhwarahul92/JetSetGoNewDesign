class Jetsteals::JetstealSeatsController < Jetsteals::BaseController

  before_filter :set_jetsteal, only: [:index]

  def index
    @jetsteal_seats = @jetsteal.jetsteal_seats
  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:jetsteal_id]
  end

end