class JetstealListCreator

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def generate_list
    @list = Jetsteal.ready_for_sale.includes(:departure_airport, :arrival_airport, :aircraft, :jetsteal_seats)
    @list = @list.where(departure_airport_id: @params[:departure_airport_id]) if @params[:departure_airport_id].present?
    @list = @list.where(arrival_airport_id: @params[:arrival_airport_id]) if @params[:arrival_airport_id].present?
    @list
  end

end