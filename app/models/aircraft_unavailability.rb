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

  validate :duplicate_times, on: :create

  validate :duplicate_times_update, on: :update

  def duplicate_times
    if self.aircraft_id.present? and self.start_at.present? and self.end_at.present?
      if self.class.where(aircraft_id: self.aircraft_id).where('? BETWEEN start_at AND end_at', self.start_at).any? or self.class.where(aircraft_id: self.aircraft_id).where('? BETWEEN start_at AND end_at', self.end_at).any?
        self.errors.add(:base, "There's already an unavailability for this aircraft in given time")
      end
    end
  end

  def duplicate_times_update
    if self.id.present?
      unavailabilities = self.class.where(aircraft_id: self.id).where('id != ?', self.id)
      if unavailabilities.where('? BETWEEN start_at AND end_at', self.start_at).any? or unavailabilities.where('? BETWEEN start_at AND end_at', self.end_at).any?
        self.errors.add :base, "There's already an unavailability for this aircraft in given time"
      end
    end
  end

end