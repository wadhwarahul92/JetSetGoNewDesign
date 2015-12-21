class JetstealLauncher

  # @param [Jetsteal] jetsteal
  def initialize(jetsteal)
    @jetsteal = jetsteal
  end

  def launch!
    if @jetsteal.sell_by_seats?
      validate_per_seat
    else
      validate_as_whole
    end
  end

  private

  def validate_as_whole
    return false unless @jetsteal.cost.present?
    return false if @jetsteal.cost <= 0
    @jetsteal.update_attribute :launched, true
  end

  def validate_per_seat
    return false unless @jetsteal.jetsteal_seats.any?
    ui_seat_ids = JetstealSeatsBuilder.new(@jetsteal).send(:find_seats_in_plane)
    return false if ui_seat_ids.length != @jetsteal.jetsteal_seats.length
    @jetsteal.jetsteal_seats.each { |s| return false if s.cost <= 0 }
    @jetsteal.update_attribute :launched, true
  end

end