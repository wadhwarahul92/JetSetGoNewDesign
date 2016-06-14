class Airport < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :city

  belongs_to :airport_category, class_name: 'AirportCategory', foreign_key: :airport_category_id

  has_many :watch_hours

  has_many :notams

  has_many :aircrafts

  has_many :handling_cost_grids

  has_many :departing_jetsteals, class_name: 'Jetsteal', foreign_key: :departure_airport_id

  has_many :arriving_jetsteals, class_name: 'Jetsteal', foreign_key: :arrival_airport_id

  has_many :departing_activities, class_name: 'Activity', foreign_key: :departure_airport_id

  has_many :arriving_activities, class_name: 'Activity', foreign_key: :arrival_airport_id

  NIGHT_LANDING_ONSET = 17 #in hours, 5 PM

  #####VALIDATIONS
  validates :name, presence: true, uniqueness: { scope: :city_id }
  validates :city, :longitude, :latitude, :ifr_or_vfr, presence: true
  # validates :code, uniqueness: true
  validates :ifr_or_vfr, inclusion: { in: %w(ifr vfr)}
  # validates :icao_code, uniqueness: true
  validates :runway_field_length_in_feet, presence: true

  # validates :airport_category_id, presence: true

  validates :bais_time_in_minutes, presence: true

  validates_numericality_of :runway_field_length_in_feet,
                            greater_than_or_equal_to: 0


  validate def icao_and_code_differs
             if self.icao_code.present? and self.code.present? and self.icao_code == self.code
               self.errors.add(:icao_code, 'cannot be same as IATA code')
             end
  end


  ################

  def distance_to(airport)

    return 0.0 if self.id == airport.id

    d = Distance.where(from_airport_id: self.id, to_airport_id: airport.id).first
    if d.present?
      d.distance_in_nm
    else
      nil
    end
  end

  ######################################################################
  # Description: It calculates the handling cost at an airport
  # @return [Float]
  ######################################################################
  def handling_cost(aircraft = nil)

    return 12400 unless aircraft.present?

    h = HandlingCostGrid.where(airport_id: self.id, aircraft_id: aircraft.id).first

    h.present? ? h.cost : 12400
  end

  ######################################################################
  # Description: It calculates the accommodation cost at an airport for given nights
  # @param [Integer] nights
  # @return [Float] cost
  ######################################################################
  def accommodation_cost(nights)
    City::TIER_ACCOMMODATION_COST[self.city.accomodation_category.to_sym] * nights
  end

end
