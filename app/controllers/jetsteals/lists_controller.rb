class Jetsteals::ListsController < Jetsteals::BaseController

  def index
    @jetsteals = Jetsteal.ready_for_sale.includes(:departure_airport, :arrival_airport, :aircraft, :jetsteal_seats)
  end

  def show
    @jetsteal = Jetsteal.find params[:id]
  end

end