class City < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :airports

  has_attached_file :image, styles: {small: '50x50!'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  ######################################################################
  # Description: Accomodation cost tier wise for cities (this remains constant)
  ######################################################################
  TIER_ACCOMMODATION_COST = {
      tier1: 40000,
      tier2: 34000,
      tier3: 30000
  }
  ######################################################################

  ######################################################################
  # Description: There is a typo mistake in "accomodation_category"
  ######################################################################
  # dont know why this produces error :(
  # alias_method :accommodation_category, :accomodation_category

  #####VALIDATIONS###
  validates :name, presence: true, uniqueness: { scope: :state }
  validates :state, presence: true
  validates :image, presence: true
  validates :accomodation_category, presence: true, inclusion: { in: %w{tier1 tier2 tier3} }
  ###################
end
