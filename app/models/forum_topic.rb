class ForumTopic < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :organisation

  belongs_to :operator

  has_many :forum_topic_comments

  validates :organisation, presence: true

  validates :operator, presence: true

  validates :statement, presence: true, length: { minimum: 5, maximum: 250 }

  validates :description, presence: true, length: { minimum: 5 }

end
