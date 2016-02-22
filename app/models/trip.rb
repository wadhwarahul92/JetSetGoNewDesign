class Trip < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :organisation

  has_many :activities

  STATUSES = %w{inquiry quoted confirmed}

  validates_presence_of :organisation, :status

  validates_inclusion_of :status, in: STATUSES

end