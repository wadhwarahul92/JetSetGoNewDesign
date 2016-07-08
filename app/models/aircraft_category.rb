class AircraftCategory < ActiveRecord::Base

  has_many :aircraft_types

  validates :name, presence: true

end
