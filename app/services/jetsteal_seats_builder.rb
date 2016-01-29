class JetstealSeatsBuilder

  # @param [Jetsteal] jetsteal
  def initialize(jetsteal)
    @jetsteal = jetsteal
  end

  def build_seats
    raise 'Asked to build seat but seats already present' if @jetsteal.jetsteal_seats.any?
    seats_in_plane = find_seats_in_plane
    seats_in_plane.each do |ui_seat_id|
      @jetsteal.jetsteal_seats.build(ui_seat_id: ui_seat_id)
    end
  end

  private

  def find_seats_in_plane
    svg_string = @jetsteal.aircraft.aircraft_type.svg(@jetsteal.aircraft)
    ui_seat_ids = svg_string.scan(/seat\d+/).sort
    seat_numbers = ui_seat_ids.map{ |s| s.gsub(/seat/, '').to_i }.sort
    seat_numbers.each_with_index do |n, i|
      #designer must have not included seat_ids in svg image
      raise 'Problem in ui_seat_ids' unless n == (i+1)
    end
    ui_seat_ids
  end

end