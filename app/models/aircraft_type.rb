class AircraftType < ActiveRecord::Base

  #####VALIDATIONS###
  validates :name, presence: true
  ###################

end
