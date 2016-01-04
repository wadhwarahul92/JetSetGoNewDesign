class JetstealSeatLocker

  #when a user is about to pay for some chosen seats
  #those seats are locked for some time to ensure that someone else dont pay for same seats

  def initialize(jetsteal_seats)
    @jetsteal_seats = jetsteal_seats
  end

  def all_allowed_for_sale?
    @jetsteal_seats.each do |jetsteal_seat|
      return false if jetsteal_seat.booked? or jetsteal_seat.locked?
    end
    true
  end

  def lock_all_for_sale
    @jetsteal_seats.each { |seat| seat.update_attribute :locked_at, DateTime.now }
    true
  end

end