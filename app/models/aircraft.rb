class Aircraft < ActiveRecord::Base

  belongs_to :aircraft_type

  has_many :aircraft_images

  accepts_nested_attributes_for :aircraft_images

  ####VALIDATIONS###
  validates :tail_number, uniqueness: true, presence: true
  validates :aircraft_type, presence: true
  ##################

end
