class Aircraft < ActiveRecord::Base

  belongs_to :aircraft_type

  ####VALIDATIONS###
  validates :tail_number, uniqueness: true
  validates :aircraft_type, presence: true
  ##################

end
