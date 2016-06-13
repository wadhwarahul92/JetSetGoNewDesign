class AirportCategory < ActiveRecord::Base

  validates :name, presence: true

end
