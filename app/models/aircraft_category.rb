class AircraftCategory < ActiveRecord::Base

  has_many :aircraft_types

  has_many :handling_cost_grids

  validates :name, presence: true

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
