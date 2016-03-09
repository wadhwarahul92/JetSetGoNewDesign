class Trip < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :organisation

  belongs_to :user

  has_many :activities

  STATUS_QUOTED = 'quoted'

  STATUS_ENQUIRY = 'enquiry'

  STATUS_CONFIRMED = 'confirmed'

  STATUSES = [STATUS_ENQUIRY, STATUS_QUOTED, STATUS_CONFIRMED]

  validates_presence_of :organisation, :status

  validates_inclusion_of :status, in: STATUSES

end