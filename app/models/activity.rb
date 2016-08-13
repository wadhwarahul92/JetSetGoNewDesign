class Activity < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :aircraft

  belongs_to :departure_airport, class_name: 'Airport', foreign_key: :departure_airport_id

  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: :arrival_airport_id

  belongs_to :trip

  validates_presence_of :aircraft, :departure_airport, :arrival_airport, :start_at, :end_at, :trip, :handling_cost_at_takeoff, :landing_cost_at_arrival, :flight_cost

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
    if self.aircraft.aircraft_unavailabilities.where('start_at BETWEEN ? AND ? OR end_at BETWEEN ? AND ? OR ? BETWEEN start_at AND end_at OR ? BETWEEN start_at AND end_at', self.start_at, self.end_at, self.start_at, self.end_at, self.start_at, self.end_at).any?
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

  validate :overlapping_activity, on: :create

  def overlapping_activity

    if self.aircraft.activities.joins('INNER JOIN trips ON activities.trip_id = trips.id').where('trips.status = ?', Trip::STATUS_CONFIRMED).where('activities.start_at BETWEEN ? AND ? OR activities.end_at BETWEEN ? AND ? OR ? BETWEEN activities.start_at AND activities.end_at OR ? BETWEEN activities.start_at AND activities.end_at', self.start_at, self.end_at, self.start_at, self.end_at, self.start_at, self.end_at).any?
      self.errors.add(:base, "There's already a confirmed trip/empty-leg in given time frame")
    end
  end

  #while creating an activity distance form A -> B must be present
  validate def presence_of_distance
    if self.departure_airport.present? and self.arrival_airport.present?
      d = Distance.where(from_airport_id: self.departure_airport_id, to_airport_id: self.arrival_airport_id).first
      if d.present? and d.distance_in_nm.present?
        # do nothing
      else
        self.errors.add(:base, 'There is no distance available from departure airport to arrival airport, contact support.')
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
      self.errors.add(:base, 'Arrival airport does not support night landing.')
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

  validate def no_pax_if_empty_leg
    self.errors.add(:pax, 'for empty leg must be zero.') if self.empty_leg? and self.pax and self.pax > 0
  end

  validate def accommodation_plan_cost
    # this error will come if manually set accommmodation cost 'Attribute was supposed to be a Hash, but was a String. -- "" '
    # want to check type self.accommodation_plan.to_yaml
    self.errors.add(:accommodation_plan, "/HOTAC can't blank.") unless self.accommodation_plan[:cost].present? if self.accommodation_plan.present?
  end

  def activity_duration
    return 0 if self.arrival_airport_id == self.departure_airport_id
    distance = self.departure_airport.distance_to(self.arrival_airport)
    speed = self.aircraft.cruise_speed_in_nm_per_hour
    ( distance / speed ).round(2)
  end

  def end_at
    self[:end_at] ||= ( self.start_at + self.activity_duration.hours )
  end

end