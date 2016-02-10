class ForumTopic < ActiveRecord::Base

  belongs_to :organisation

  belongs_to :operator

  validates :organisation, presence: true

  validates :operator, presence: true

end
