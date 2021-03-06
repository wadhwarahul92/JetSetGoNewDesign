class Organisation < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_attached_file :image, styles: {small: '50x50!', size_250x250: '250x250!'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_many :forum_topics

  has_many :operators

  has_many :aircrafts

  has_many :forum_topic_comments

  has_many :trips

  has_many :organisation_documents

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
