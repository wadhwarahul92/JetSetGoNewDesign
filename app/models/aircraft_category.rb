class AircraftCategory < ActiveRecord::Base

  has_many :aircraft_types

  has_many :handling_cost_grids

  validates :name, presence: true

end
