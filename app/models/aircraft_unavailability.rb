class AircraftUnavailability < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :aircraft

  validates_presence_of :aircraft_id, :start_at, :end_at, :reason

  validate def start_at_lesser
             if self.start_at.present? and self.end_at.present?
               self.errors.add(:end_at, 'must come after start at') if self.end_at <= self.start_at
             end
  end

  validate def duplicate_times
    if self.aircraft_id.present? and self.start_at.present? and self.end_at.present?
      if self.class.where(aircraft_id: self.aircraft_id).where(
                                                         '? BETWEEN start_at AND end_at OR ? BETWEEN start_at AND end_at', self.start_at, self.end_at
      ).any?
        self.errors.add(:base, "There's already an unavailability for this aircraft in given time")
      end
    end
  end

  validate def confirmed_trip
             return unless self.aircraft_id.present?
             if Activity.where(
                 aircraft_id: self.aircraft_id
             ).joins(
                 'INNER JOIN trips ON activities.trip_id = trips.id'
             ).where(
                  'trips.status = ?', Trip::STATUS_CONFIRMED
             ).where(
                  'activities.start_at BETWEEN ? AND ? OR activities.end_at BETWEEN ? AND ? OR ? BETWEEN activities.start_at AND activities.end_at OR ? BETWEEN activities.start_at AND activities.end_at', self.start_at, self.end_at, self.start_at, self.end_at, self.start_at, self.end_at
             ).any?
               self.errors.add(:base, 'There is a confirmed trip in the given time frame.')
             end
  end

end