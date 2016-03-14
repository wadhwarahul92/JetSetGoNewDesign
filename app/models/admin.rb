class Admin < User

  include VersionTracker

  has_paper_trail

  has_many :admin_roleships

  JSG_COMMISSION_IN_PERCENTAGE = 10

  class <<self

    def get_all_emails
      self.all.map(&:email)
    end

  end

end