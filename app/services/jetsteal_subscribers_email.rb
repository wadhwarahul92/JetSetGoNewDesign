class JetstealSubscribersEmail

  # @param [Jetsteal] jetsteal
  def initialize(jetsteal)
    @jetsteal = jetsteal
    @subscribers = []
  end

  def send_all
    find_matching_subscribers
    # _send
    # AdminMailer.new_jetsteal(@jetsteal, @subscribers).deliver_later
    true #return true signifies that emails are sent
  end

  private

  def find_matching_subscribers
    JetstealSubscription.where(departure_airport: @jetsteal.departure_airport.id.to_s).each{ |j| @subscribers << j }
    JetstealSubscription.where(arrival_airport: @jetsteal.arrival_airport.id.to_s).each{ |j| @subscribers << j }
    JetstealSubscription.where(arrival_airport: nil, departure_airport: nil, date: nil, pax: nil).each { |j| @subscribers << j }
    @subscribers.uniq!
  end

  def _send
    @subscribers.each do |subscriber|
      JetstealMailer.email_to_subscriber(@jetsteal, subscriber).deliver_later
    end
  end

end