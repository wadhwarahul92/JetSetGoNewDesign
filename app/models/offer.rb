class Offer < ActiveRecord::Base

  has_attached_file :image, presence: true, styles: {small: '50x50!'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ , :if => :image_attached?

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :category, presence: true
  validates :image, presence: true

  def image_attached?
    self.image.present?
  end

  validate def end_date_after_start_date
    if self.start_at.present? && self.end_at.present? && self.start_at >= self.end_at
      self.errors.add(:end_at, 'must come after Start time')
    end
  end

end