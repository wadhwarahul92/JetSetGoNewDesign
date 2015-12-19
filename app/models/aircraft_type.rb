class AircraftType < ActiveRecord::Base

  has_many :aircrafts

  #####VALIDATIONS###
  validates :name, presence: true
  ###################

end
