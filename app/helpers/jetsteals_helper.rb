module JetstealsHelper

  # @param [Jetsteal] jetsteal
  def jetsteal_icons(jetsteal)
    wifi    = jetsteal.aircraft.wifi
    phone   = jetsteal.aircraft.phone
    attendant  = jetsteal.aircraft.flight_attendant
    crew    = jetsteal.aircraft.crew
    seat    = jetsteal.aircraft.seating_capacity
    height  = (jetsteal.aircraft.cabin_height_in_meters * 3.28).round(2)
    toilet  = jetsteal.aircraft.number_of_toilets
    baggage = jetsteal.aircraft.baggage_capacity_in_kg
    speed = jetsteal.aircraft.aircraft_type.speed_in_kts

    view = ''
    view += "<div class='col-sm-6'><i class='fa fa-wifi' data-toggle='tooltip' data-original-title='Wifi'></i></div>" if wifi
    view += "<div class='col-sm-6'><i class='fa fa-phone' data-toggle='tooltip' data-original-title='Phone'></i></div>" if phone
    view += "<div class='col-sm-6'><i class='fa fa-female' data-toggle='tooltip' data-original-title='Flight Attendant'></i> #{attendant}</div>" if attendant.present? && !(attendant < 1)
    view += "<div class='col-sm-6'><i class='fa fa-wifi' data-toggle='tooltip' data-original-title='Crew'></i> #{crew}</div>" if crew.present?
    view += "<div class='col-sm-6'><i class='fa fa-user' data-toggle='tooltip' data-original-title='Seats'></i> #{seat}</div>" if seat.present?
    view += "<div class='col-sm-6'><i class='fa fa-fighter-jet' data-toggle='tooltip' data-original-title='Height'></i><i class='fa fa-arrows-v'></i> #{height} ft</div>" if height.present?
    view += "<div class='col-sm-6'><i class='fa fa-wifi' data-toggle='tooltip' data-original-title='Lavoratory'></i> #{toilet}</div>" if toilet.present? && !(toilet < 1)
    view += "<div class='col-sm-6'><i class='fa fa-suitcase' data-toggle='tooltip' data-original-title='Baggage Capacity'></i> #{baggage} Kg</div>" if baggage.present?
    view += "<div class='col-sm-6'><i class='fa fa-tachometer' data-toggle='tooltip' data-original-title='Speed'></i> #{speed} Kts</div>" if speed.present?

    raw view
  end

end
