class AircraftType < ActiveRecord::Base

  include VersionTracker

  has_paper_trail skip: [:svg]

  has_many :aircrafts

  #####VALIDATIONS###
  validates :name, presence: true
  validates :svg, presence: true
  # validates :speed_in_kts, presence: true
  validates :description, presence: true
  validates_numericality_of :speed_in_kts,
  
  							# only_integer: true,
  							greater_than_or_equal_to: 0
  ###################

end
