class Jetsteal < ActiveRecord::Base

  has_paper_trail

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

  ###########

end
