class HandlingCostGrid < ActiveRecord::Base

  # belongs_to :aircraft
  # belongs_to :airport
  # ============
  belongs_to :aircraft_category
  belongs_to :city
  # ============

  # validates_presence_of :aircraft_id
  # validates_presence_of :airport_id
   validates_presence_of :city_id
   validates_presence_of :aircraft_category_id
  validates_presence_of :cost

  validates :cost, numericality: { greater_than: 0 }

end
