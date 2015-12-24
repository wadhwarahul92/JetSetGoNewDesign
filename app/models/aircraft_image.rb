class AircraftImage < ActiveRecord::Base

  belongs_to :aircraft

  #validations
  validates :aircraft, presence: true
  ############

  has_attached_file :image, styles: {small: '50x50#', medium: '100x100#', large: '200x200#'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
