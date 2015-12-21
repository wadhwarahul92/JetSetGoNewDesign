class Jetsteal < ActiveRecord::Base

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  belongs_to :aircraft

  #validations
  validates :departure_airport, presence: true
  validates :arrival_airport, presence: true
  validates :aircraft, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate def end_date_after_start_date
             if self.start_at > self.end_at
               self.errors.add(:end_at, 'must come after Start time')
             end
  end
  ############

end
