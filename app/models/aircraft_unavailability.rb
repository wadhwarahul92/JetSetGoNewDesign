class AircraftUnavailability < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft

  validates_presence_of :aircraft_id, :start_at, :end_at, :reason

  validate def start_at_lesser
             if self.start_at.present? and self.end_at.present?
               self.errors.add(:end_at, 'must come after start at') if self.end_at <= self.start_at
             end
  end

end