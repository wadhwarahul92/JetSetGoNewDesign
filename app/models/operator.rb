class Operator < User

  include VersionTracker

  has_paper_trail

  serialize :roles, Array

  has_many :forum_topics

  has_many :aircrafts

  belongs_to :organisation

  has_many :forum_topic_comments

  scope :verified, -> { where(approved_by_admin: true) }

  validates :organisation, presence: true
  validates :designation, presence: true

  def is_admin?
    @is_admin ||= self.roles.include?('admin')
  end

end