class JetstealContactCreator

  def initialize(jetsteal_id, jetsteal_seat_ids, first_name, last_name, email, phone)
    @jetsteal = Jetsteal.find jetsteal_id
    @jetsteal_seats = JetstealSeat.where(id: jetsteal_seat_ids)
    @contact = Contact.where(email: email).first || Contact.create(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone
    )
  end

  def validated_seats!
    @jetsteal_seats.each do |jetsteal_seat|
      if jetsteal_seat.cc_avenue_transaction_id.present?
        return false
      end
    end
    true
  end

  def cc_avenue_transaction
    @cc_avenue_transaction ||= CcAvenueTransaction.create!(contact_id: @contact.id)
  end

  def amount
    @jetsteal_seats.map(&:cost).inject(:+)
  end

end