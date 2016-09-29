class Aircraft < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  acts_as_paranoid

  belongs_to :aircraft_type

  has_many :aircraft_images

  # belongs_to :operator

  belongs_to :base_airport, class_name: 'Airport', foreign_key: :base_airport_id

  belongs_to :organisation

  has_many :aircraft_unavailabilities

  has_many :activities

  has_many :handling_cost_grids

  accepts_nested_attributes_for :aircraft_images

  before_validation :upcase_tail_number

  ####VALIDATIONS###
  validates :tail_number, uniqueness: true, presence: true,:case_sensitive => false, length: { minimum: 5, maximum: 6 }
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
                        # :catering_cost_per_pax,
                        :organisation_id,
                        :base_airport_id

  validates :organisation, presence: true
  validates :year_of_manufacture, length: { is: 4 }, numericality: true
  validates_format_of :tail_number, :with => /\AVT-[A-Z0-9]{3}\z/i

  validates_numericality_of :seating_capacity,
                            :baggage_capacity_in_kg,
                            :runway_field_length_in_feet,
                            :cabin_height_in_meters,
                            :cabin_width_in_meters,
                            :cruise_speed_in_nm_per_hour,
                            :flying_range_in_nm,
                            :per_hour_cost,
                            # :catering_cost_per_pax,
                            # :landing_field_length_in_feet,
                            :number_of_toilets,
                            # :cabin_length_in_meters,
                            :crew,

                            # only_integer: true,
                            greater_than_or_equal_to: 0
  ##################
  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_attached_file :interior, styles: { size_400x400: '400x400'}
  validates_attachment_content_type :interior, content_type: /\Aimage\/.*\Z/

  has_attached_file :specification_image
  validates_attachment_content_type :specification_image, content_type: /\Aimage\/.*\Z/

  has_attached_file :range_map_image
  validates_attachment_content_type :range_map_image, content_type: /\Aimage\/.*\Z/

  def upcase_tail_number
    self.tail_number = self.tail_number.upcase if self.tail_number.present?
  end

  def ready_for_frontend?
    has_atleast_one_image? and self.admin_verified?
  end


  ######################################################################
  # Description: returns true if there is no aircraft unavailabilty for current time
  # @return [Boolean]
  ######################################################################
  def is_working?
    !self.aircraft_unavailabilities.where('? BETWEEN start_at AND end_at', DateTime.now).any?
  end

  # @param [Airport] departure_airport
  # @param [Airport] arrival_airport
  def flight_time_in_hours_for(departure_airport, arrival_airport)
    departure_airport.distance_to(arrival_airport) / self.cruise_speed_in_nm_per_hour
  end

  def mtow_useable
    self.mtow || self.aircraft_type.mtow
  end

  private

  def has_atleast_one_image?
    self.aircraft_images.count > 0
  end

end
