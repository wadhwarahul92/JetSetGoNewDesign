class Activity < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  belongs_to :trip

  validates_presence_of :aircraft, :departure_airport, :arrival_airport, :start_at, :end_at, :trip

  ######################################################################
  # Description: An activity can have an accommodation plan, accommodation plan kicks in as soon as activity ends
  ######################################################################
  serialize :accommodation_plan, Hash

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

  validate def pax_if_not_empty_leg
             if self.empty_leg? and self.pax.blank?
               self.errors.add(:pax, 'cannot be blank')
             end
  end

  validate def overlapping_activity
             aircraft_activities = self.aircraft.activities.joins(
                                                               'LEFT OUTER JOIN trips ON trips.id = activities.trip_id'
             ).where('trips.status = ?', Trip::STATUS_CONFIRMED)
             if aircraft_activities.where('? BETWEEN start_at AND end_at', self.start_at).any? or
                 aircraft_activities.where('? BETWEEN start_at AND end_at', self.end_at).any?
               self.errors.add(:base, "There's already an activity in given time frame")
             end
  end

  #while creating an activity distance form A -> B must be present
  validate def presence_of_distance
             if self.departure_airport.present? and self.arrival_airport.present?
               d = Distance.where(from_airport_id: self.departure_airport_id, to_airport_id: self.arrival_airport_id).first
               if d.present? and d.distance_in_nm.present?
                 # do nothing
               else
                 self.errors.add(:base, 'There is not distance available from departure airport to arrival airport, contact support.')
               end
             end
  end

  validate def aircraft_ready_for_frontend
             if self.aircraft.ready_for_frontend?
               #do nothing
             else
               self.errors.add(:base, 'This aircraft is not approved by us yet, contact support.')
             end
  end

  validate def night_landing_requirement
             if self.end_at.hour > Airport::NIGHT_LANDING_ONSET and !self.arrival_airport.night_landing?
               self.add(:end_at, 'arrival airport does not supports night landing.')
             end
  end

  #todo: complete this
  # validate def runway_length_adequate
  #            if self.aircraft.runway_field_length_in_feet < self.arrival_airport.
  # end

  validate def aircraft_flying_range
    if self.aircraft.flying_range_in_nm < self.departure_airport.distance_to(self.arrival_airport)
      self.errors.add(:aircraft, 'has lesser range than distance form departure airport to arrival airport')
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