class JetstealListCreator

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def generate_list
    @list = Jetsteal.ready_for_sale.includes(:departure_airport, :arrival_airport, :aircraft, :jetsteal_seats)
    @list = @list.where(departure_airport_id: @params[:departure_airport_id]) if @params[:departure_airport_id].present?
    @list = @list.where(arrival_airport_id: @params[:arrival_airport_id]) if @params[:arrival_airport_id].present?
    @list = filter_by_aircraft_id(@list) if @params[:aircraft_type_id].present?
    @list = filter_by_wifi(@list) if @params[:wifi].present? && @params[:wifi] == 'Yes'
    @list = filter_by_phone(@list) if @params[:phone].present? && @params[:phone] == 'Yes'
    @list = filter_by_condition(@list, @params[:crew], 'crew') if @params[:crew].present?
    @list = filter_by_condition(@list, @params[:flight_attendant], 'flight_attendant') if @params[:flight_attendant].present?
    @list
  end

  def filter_by_aircraft_id(list)
    list.joins(:aircraft).merge(Aircraft.where(:aircraft_type_id => @params[:aircraft_type_id]))
  end

  def filter_by_wifi(list)
    list.joins(:aircraft).merge(Aircraft.where(:wifi => true))
  end

  def filter_by_phone(list)
    list.joins(:aircraft).merge(Aircraft.where(phone: true))
  end

  def filter_by_condition(list,condition1,condition2)
    if condition1 == 'Yes'
      list.joins(:aircraft).merge(Aircraft.where("#{condition2} > 0"))
    else
      list.joins(:aircraft).merge(Aircraft.where("#{condition2} < 1"))
    end
  end

end