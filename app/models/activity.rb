class Activity < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  validates_presence_of :aircraft, :departure_airport, :arrival_airport, :start_at, :end_at

  validate def end_at_after_start_at
             if self.start_at.present? and self.end_at.present?
               self.errors.add(:end_at, 'must come after start at')
             end
  end

  validate def not_in_unavailability
             aircraft_unavailabilities = self.aircraft.aircraft_unavailabilities
             if aircraft_unavailabilities.where('? BETWEEN start_at AND end_at', self.start_at) or
                 aircraft_unavailabilities.where('? BETWEEN start_at AND end_at', self.end_at)
               self.errors.add(:base, 'There is an unavailability for this aircraft in given time')
             end
  end

end