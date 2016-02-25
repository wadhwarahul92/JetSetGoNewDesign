class Airport < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :city

  has_many :watch_hours

  has_many :notams

  has_many :departing_jetsteals, class_name: 'Jetsteal', foreign_key: :departure_airport_id

  has_many :arriving_jetsteals, class_name: 'Jetsteal', foreign_key: :arrival_airport_id

  has_many :departing_activities, class_name: 'Activity', foreign_key: :departure_airport_id

  has_many :arriving_activities, class_name: 'Activity', foreign_key: :arrival_airport_id

  #####VALIDATIONS
  validates :name, presence: true, uniqueness: { scope: :city_id }
  validates :city, :longitude, :latitude, :ifr_or_vfr, presence: true
  validates :code, uniqueness: true
  validates :ifr_or_vfr, inclusion: { in: %w(ifr vfr)}
  validates :icao_code, uniqueness: true


  validate def icao_and_code_differs
             if self.icao_code.present? and self.code.present? and self.icao_code == self.code
               self.errors.add(:icao_code, 'cannot be same as IATA code')
             end
  end

  ################

  def distance_to(airport)
    d = Distance.where(from_airport_id: self.id, to_airport_id: airport.id).first
    if d.present?
      d.distance_in_nm
    else
      nil
    end
  end

end
