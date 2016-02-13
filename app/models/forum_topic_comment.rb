class ForumTopicComment < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :operator

  belongs_to :organisation

  belongs_to :forum_topic

  validates :operator, presence: true

  validates :organisation, presence: true

  validates :comment, presence: true, length: { minimum: 5 }

end