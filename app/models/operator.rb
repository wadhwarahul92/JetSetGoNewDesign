class Operator < User

  include VersionTracker

  has_paper_trail

  serialize :roles, Array

  has_many :aircrafts

  belongs_to :organisation

  scope :verified, -> { where(approved_by_admin: true) }

  validates :organisation, presence: true

end