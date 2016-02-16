class WatchHour < ActiveRecord::Base

  validates :airport_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  validate def end_date_after_start_date
    if self.start_at >= self.end_at
      self.errors.add(:end_at, 'must come after Start time')
    end
  end

end
