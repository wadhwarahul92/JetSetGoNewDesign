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
    view += "<div class='col-sm-6'><i class='fa fa-female' data-toggle='tooltip' data-original-title='Flight Attendant'></i></div>" if attendant
    view += "<div class='col-sm-6'><i class='fa fa-wifi' data-toggle='tooltip' data-original-title='Crew'></i> #{crew}</div>" if crew.present?
    view += "<div class='col-sm-6'><i class='fa fa-user' data-toggle='tooltip' data-original-title='Seats'></i> #{seat}</div>" if seat.present?
    view += "<div class='col-sm-6'><i class='fa fa-fighter-jet' data-toggle='tooltip' data-original-title='Height'></i><i class='fa fa-arrows-v'></i> #{height} ft</div>" if height.present?
    view += "<div class='col-sm-6'><i class='fa fa-wifi' data-toggle='tooltip' data-original-title='Lavoratory'></i> #{toilet}</div>" if toilet.present? && !(toilet < 1)
    view += "<div class='col-sm-6'><i class='fa fa-suitcase' data-toggle='tooltip' data-original-title='Baggage Capacity'></i> #{baggage} Kg</div>" if baggage.present?
    view += "<div class='col-sm-6'><i class='fa fa-tachometer' data-toggle='tooltip' data-original-title='Speed'></i> #{speed} Kts</div>" if speed.present?

    view.html_safe
  end

  # @param [JetSteal] jetsteal
  def jetsteal_inline_icons(jetsteal)
    seat    = jetsteal.aircraft.seating_capacity
    wifi    = jetsteal.aircraft.wifi
    phone   = jetsteal.aircraft.phone
    attendant  = jetsteal.aircraft.flight_attendant


    view = ' '
    view += "<li data-toggle='tooltip' title='Seating capacity'><i class='fa fa-user'></i> #{seat}</li>" if seat.present?
    view += "<li data-toggle='tooltip' title='Wifi'><i class='fa fa-wifi'></i></li>" if wifi && !params[:wifi].present?
    view += "<li data-toggle='tooltip' title='phone'><i class='fa fa-phone'></i></li>" if phone && !params[:phone].present?
    view += "<li data-toggle='tooltip' title='Flight Attendant'><i class='fa fa-female '></i></li> " if attendant

    view.html_safe
  end

  # @param [Integer] number
  # @return [String]
  # def to_indian_format(number)
  #   number = number.to_i.to_s
  #   formatted_number = ''
  #   number.split('').reverse.each_with_index do |char, index|
  #     if index < 3
  #       formatted_number.prepend(char)
  #       next
  #     end
  #     if index == 3
  #       # noinspection RubyResolve
  #       formatted_number.prepend ','
  #       formatted_number.prepend(char)
  #       next
  #     end
  #     if index % 2 == 0
  #       # noinspection RubyResolve
  #       formatted_number.prepend(char)
  #       formatted_number.prepend ','
  #     end
  #   end
  #   formatted_number[0] = '' if formatted_number[0] == ','
  #   formatted_number
  # end

  def to_indian_format(number)
    number_part = number.to_s.split('.')[0]
    decimal_part = number.to_s.split('.')[1]
    formatted_number = ''
    int = 0
    one_added = true
    two_added = true
    number_part.reverse.each_char do |char|
      if int < 3
        formatted_number.prepend(char)
      else
        if one_added and two_added
          formatted_number.prepend(',')
          formatted_number.prepend(char)
          one_added = true
          two_added = false
        elsif one_added and !two_added
          two_added = true
          formatted_number.prepend(char)
        elsif !one_added and !two_added
          one_added = true
          formatted_number.prepend(char)
        end
      end
      int += 1
    end
    formatted_number[0] = '' if formatted_number[0] == ','
    formatted_number = formatted_number + '.' + decimal_part if decimal_part.present?
    formatted_number
  end

end
