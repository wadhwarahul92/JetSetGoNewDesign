class Activity < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  belongs_to :trip

  validates_presence_of :aircraft, :departure_airport, :arrival_airport, :start_at, :end_at, :trip

  validate def end_at_after_start_at
             if self.start_at.present? and self.end_at.present? and self.end_at <= self.start_at
               self.errors.add(:end_at, 'must come after start at')
             end
  end

  validate def not_in_unavailability
             aircraft_unavailabilities = self.aircraft.aircraft_unavailabilities
             if aircraft_unavailabilities.where('? BETWEEN start_at AND end_at', self.start_at).any? or
                 aircraft_unavailabilities.where('? BETWEEN start_at AND end_at', self.end_at).any?
               self.errors.add(:base, 'There is an unavailability for this aircraft in given time')
             end
  end

  validate def arrival_and_departure_airport
              if self.departure_airport_id == self.arrival_airport_id
                self.errors.add(:arrival_airport, 'must be different')
              end
  end

  validate def pax_less_than_max_pax
             if self.pax and ( self.pax > self.aircraft.seating_capacity )
               self.errors.add(:pax, 'must be less than seating capacity of aircraft')
             end
  end

  validate def overlapping_activity
             aircraft_activities = self.aircraft.activities
             if aircraft_activities.where('? BETWEEN start_at AND end_at', self.start_at).any? or
                 aircraft_activities.where('? BETWEEN start_at AND end_at', self.end_at).any?
               self.errors.add(:base, "There's already an activity in given time frame")
             end
  end

  def activity_duration
    distance = self.departure_airport.distance_to(self.arrival_airport)
    speed = self.aircraft.cruise_speed_in_nm_per_hour
    ( distance / speed ).round(2)
  end

  def end_at
    self[:end_at] ||= ( self.start_at + self.activity_duration.hours )
  end

end