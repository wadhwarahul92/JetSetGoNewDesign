class Admin < User

  include VersionTracker

  has_paper_trail

  has_many :admin_roleships

  class <<self

    def get_all_emails
      self.all.map(&:email)
    end

  end

end