class Operator < User

  include VersionTracker

  has_paper_trail

  has_many :aircrafts

  scope :verified, -> { where(approved_by_admin: true) }

end