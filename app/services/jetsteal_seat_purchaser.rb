class JetstealSeatPurchaser

  def initialize(jetsteal_id, jetsteal_seat_ids, first_name, last_name, phone, email)
    @jetsteal = Jetsteal.find jetsteal_id
    @jetsteal_seats = JetstealSeat.where(id: jetsteal_seat_ids)
    @contact = Contact.where(email: email).first || Contact.create!(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone
    )
  end

  def contact
    @contact
  end

  def payment_transaction
    @transaction ||= @contact.payment_transactions.create!
  end

  def validated_seats!
    @jetsteal_seats.each do |jetsteal_seat|
      if jetsteal_seat.payment_transaction_id.present?
        payment_transaction.update_attribute(:status, 'failed')
        return false
      end
    end
    true
  end

  def amount
    @jetsteal_seats.map(&:cost).inject(:+)
  end

  def jetsteal_seats
    @jetsteal_seats
  end

  def jetsteal
    @jetsteal
  end

end