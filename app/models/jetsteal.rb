class Jetsteal < ActiveRecord::Base

  attr_accessor :sold_out

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  belongs_to :aircraft

  has_many :jetsteal_seats

  accepts_nested_attributes_for :jetsteal_seats

  # Gives the jetsteals that are ready for sale and can be presented to customer
  # launched = true
  # DateTime.now IS in BETWEEN start_at and end_at
  scope :ready_for_sale, ->{ where(launched: true).where('? BETWEEN start_at AND end_at', DateTime.now) }

  #validations
  validates :departure_airport, presence: true
  validates :arrival_airport, presence: true
  validates :aircraft, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :flight_duration_in_minutes, presence: true
  validates_numericality_of :cost,

                            # only_integer: true,
                            greater_than_or_equal_to: 0

  validate def end_date_after_start_date
    if self.start_at >= self.end_at
      self.errors.add(:end_at, 'must come after Start time')
    end
  end
  validate def arrival_and_departure_airports
    if self.arrival_airport == self.departure_airport
      self.errors.add(:arrival_airport_id, 'must be different')
    end
  end
  validate def cost_if_no_sell_by_seats
    unless self.sell_by_seats
      self.errors.add(:cost, 'is required if not selling by seats') unless self.cost.present?
    end
  end
  validate def flight_time_greater_than_zero
             if self.flight_duration_in_minutes and self.flight_duration_in_minutes <= 0
               self.errors.add :flight_duration_in_minutes, 'must be greater than 0'
             end
  end

  ###########

  def can_be_sold_as_whole?
    jetsteal_seats.each{ |seat| return false if seat.booked? }
    cost.present? and cost.to_f > 0
  end

  def min_seat_cost
    min = Float::INFINITY
    jetsteal_seats.each do |jetsteal_seat|
      if jetsteal_seat.cost.present?
        min = jetsteal_seat.cost if jetsteal_seat.cost < min
      end
    end
    min
  end

  def payment_transaction
    PaymentTransaction.find self.id
  end

end
