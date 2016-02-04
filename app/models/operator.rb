class Operator < User

  include VersionTracker

  has_paper_trail

  has_many :aircrafts

end