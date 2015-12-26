class AircraftImage < ActiveRecord::Base

  has_paper_trail

  belongs_to :aircraft

  #validations
  validates :aircraft, presence: true
  ############

  has_attached_file :image, styles: {small: '50x50!', medium: '200x200>', large: '400x400>', large_square: '400x400!'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
