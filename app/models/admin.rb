class Admin < User

  include VersionTracker

  has_paper_trail

  has_many :admin_roleships
end