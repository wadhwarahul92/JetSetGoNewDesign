class WatchHour < ActiveRecord::Base

  belongs_to :airport

  validates :airport_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  validate def end_date_after_start_date
    if self.start_at.present? && self.end_at.present? && self.start_at >= self.end_at
      self.errors.add(:end_at, 'must come after Start time')
    end
  end

  #todo this is stub, change this
  def cost
    rand(10000..50000)
  end

end
