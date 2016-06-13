class Supplier < ActiveRecord::Base

  validates :name, presence: true
  validate :fuel_supplier
  validate :ground_handling
  validate :other_services

end
