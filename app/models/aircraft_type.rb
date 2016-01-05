class AircraftType < ActiveRecord::Base

  include VersionTracker

  has_paper_trail skip: [:svg]

  has_many :aircrafts

  #####VALIDATIONS###
  validates :name, presence: true
  validates :svg, presence: true
  validates :speed_in_kts, presence: true
  ###################

end
