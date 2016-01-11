class JetstealListCreator

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def generate_list

    @list = Jetsteal.ready_for_sale.includes(:departure_airport, :arrival_airport).joins(
        'LEFT OUTER JOIN aircrafts ON jetsteals.aircraft_id = aircrafts.id'
    ).joins(
         'LEFT OUTER JOIN aircraft_types ON aircrafts.aircraft_type_id = aircrafts.id'
    )

    @list = @list.where(departure_airport_id: @params[:departure_airport_id]) if @params[:departure_airport_id].present?

    @list = @list.where(arrival_airport_id: @params[:arrival_airport_id]) if @params[:arrival_airport_id].present?

    filter_facilities

    @list
  end

  private

  def filter_facilities

    [:wifi, :phone, :flight_attendant].each do |attr|

      case @params[attr]
        when 'Yes'
          @list = @list.where("aircrafts.#{attr.to_s} IS TRUE")
        when 'No'
          @list = @list.where("aircrafts.#{attr.to_s} IS FALSE OR aircrafts.#{attr.to_s} IS NULL")
        else
          #do nothing
      end

    end

  end

end