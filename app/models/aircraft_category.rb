class AircraftCategory < ActiveRecord::Base

  validates :name, presence: true

end
