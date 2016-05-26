class HandlingCostGrid < ActiveRecord::Base

  validates_presence_of :aircraft_id
  validates_presence_of :airport_id
  validates_presence_of :cost

end
