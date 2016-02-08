class Operator < User

  include VersionTracker

  has_paper_trail

  has_many :aircrafts

  belongs_to :organisation

  scope :verified, -> { where(approved_by_admin: true) }

end