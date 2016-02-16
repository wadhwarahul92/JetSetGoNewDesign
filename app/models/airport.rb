class Airport < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :city

  has_many :departing_jetsteals, class_name: 'Jetsteal', foreign_key: :departure_airport_id

  has_many :arriving_jetsteals, class_name: 'Jetsteal', foreign_key: :arrival_airport_id

  #####VALIDATIONS
  validates :name, presence: true, uniqueness: { scope: :city_id }
  validates :city, :longitude, :latitude, :ifr_or_vfr, :code, presence: true
  validates :code, length: { is: 3 }, presence: true
  validates :ifr_or_vfr, inclusion: { in: %w(ifr vfr)}
  validates :icao_code, presence: true, uniqueness: true
  ################

  def distance_to(airport)
    d = Distance.where(from_airport_id: self.id, to_airport_id: airport.id).first
    if d.present?
      d.distance
    else
      nil
    end
  end

end
