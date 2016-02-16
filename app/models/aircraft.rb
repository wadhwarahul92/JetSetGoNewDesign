class Aircraft < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :aircraft_type

  has_many :aircraft_images

  # belongs_to :operator

  belongs_to :organisation

  has_many :aircraft_unavailabilities

  accepts_nested_attributes_for :aircraft_images

  ####VALIDATIONS###
  validates :tail_number, uniqueness: true, presence: true, length: { minimum: 5, maximum: 6 }
  validates :aircraft_type, presence: true
  validates_presence_of :seating_capacity,
                        :baggage_capacity_in_kg,
                        # :landing_field_length_in_feet,
                        :runway_field_length_in_feet,
                        :number_of_toilets,
                        :cabin_height_in_meters,
                        # :cabin_length_in_meters,
                        :cabin_width_in_meters,
                        # :memorable_name,
                        :crew,
                        :year_of_manufacture,
                        :cruise_speed_in_nm_per_hour,
                        :flying_range_in_nm,
                        :per_hour_cost,
                        :catering_cost_per_pax,
                        :organisation_id
  validates :organisation, presence: true
  validates :year_of_manufacture, length: { is: 4 }, numericality: true
  ##################

end
