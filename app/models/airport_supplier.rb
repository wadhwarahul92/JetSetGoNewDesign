class AirportSupplier < ActiveRecord::Base

  validates :halt_type, presence: true
  validates :maximum_mtow , presence: true
  validates :minimum_amount , presence: true
  validates :offset_amount , presence: true
  validates :rate_per_tonne , presence: true
  validates :royalty , presence: true
  validates :additional_rate , presence: true
  validate :max_other_service
  validates :maximum_mtow , presence: true
  validates :other_service_cost , presence: true

end
