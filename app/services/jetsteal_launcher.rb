class JetstealLauncher

  # @param [Jetsteal] jetsteal
  def initialize(jetsteal)
    @jetsteal = jetsteal
  end

  def launch!
    return false unless check_airport_distance
    if @jetsteal.sell_by_seats?
      validate_per_seat and check_aircraft_images and @jetsteal.update_attribute :launched, true and JetstealSubscribersEmail.new(@jetsteal).send_all
    else
      validate_as_whole and check_aircraft_images and @jetsteal.update_attribute :launched, true and JetstealSubscribersEmail.new(@jetsteal).send_all
    end
  end

  def error_message
    @message if @message.present?
  end

  private

  def check_aircraft_images
    unless @jetsteal.aircraft.aircraft_images.any?
      @message = 'The aircraft associated with this jetsteal has no images'
      return false
    end
    true
  end

  def validate_as_whole
    if @jetsteal.cost.blank? or @jetsteal.cost <= 0
      @message = 'This jetsteal is marked to be sold as whole but it has no price'
      return false
    end
    true
  end

  def validate_per_seat
    unless @jetsteal.jetsteal_seats.any?
      @message = 'One or more seat in this jetsteal have no price'
      return false
    end
    ui_seat_ids = JetstealSeatsBuilder.new(@jetsteal).send(:find_seats_in_plane)
    if ui_seat_ids.length != @jetsteal.jetsteal_seats.length
      @message = 'One or more seat in this jetsteal have no price'
      return false
    end
    @jetsteal.jetsteal_seats.each do |s|
      if !s.disabled? and s.cost.blank? or (!s.disabled? and s.cost <= 0)
        @message = 'One or more seat in this jetsteal have no price'
        return false
      end
    end
    true
  end

  def check_airport_distance
    d = Distance.where(from_airport_id: @jetsteal.departure_airport_id, to_airport_id: @jetsteal.arrival_airport_id).first
    if d.present?
      true
    else
      @message = 'Distance from Departure to Arrival airport is not present. Go to distance and create an entry for same.'
      false
    end
  end

end