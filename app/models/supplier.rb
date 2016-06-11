class Supplier < ActiveRecord::Base

  validate :name, presence: true
  validate :fuel_supplier, presence: true
  validate :ground_handling, presence: true
  validate :other_services, presence: true

end
