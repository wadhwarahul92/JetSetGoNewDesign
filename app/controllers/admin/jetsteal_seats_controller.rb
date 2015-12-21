class Admin::JetstealSeatsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jetsteal

  def index
    JetstealSeatsBuilder.new(@jetsteal).build_seats unless @jetsteal.jetsteal_seats.any?
  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:jetsteal_id]
  end

end