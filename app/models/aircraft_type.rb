class AircraftType < ActiveRecord::Base

  include VersionTracker

  has_paper_trail skip: [:svg]

  has_many :aircrafts

  #####VALIDATIONS###
  validates :name, presence: true
  validates :svg, presence: true
  validates :speed_in_kts, presence: true
  validates :description, presence: true
  ###################

  #overirde #svg to return aircrafts svg if it is present

  def svg(aircraft = nil)
    if aircraft.present?
      aircraft.svg || self[:svg]
    else
      self[:svg]
    end
  end

  #######

end
