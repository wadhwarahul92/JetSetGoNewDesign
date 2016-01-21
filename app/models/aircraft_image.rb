class AircraftImage < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft

  #validations
  validates :aircraft, presence: true
  ############

  DEFAULT_SIZE = :size_250x250

  has_attached_file :image, styles: {small: '50x50!', size_250x250: '250x250'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
