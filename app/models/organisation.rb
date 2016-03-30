class Organisation < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :forum_topics

  has_many :operators

  has_many :aircrafts

  has_many :forum_topic_comments

  has_many :trips

  validates :name, presence: true, uniqueness: true, length: {minimum: 5}

  def has_admin?
    self.operators.each do |operator|
      return true if operator.roles.include?('admin')
    end
    false
  end

  class <<self

    def get_all_emails(organisation)
      self.find(organisation.id).operators.map(&:email)
    end

  end

end
