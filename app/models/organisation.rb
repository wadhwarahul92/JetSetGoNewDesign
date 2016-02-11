class Organisation < ActiveRecord::Base

  has_many :forum_topics

  has_many :operators

  has_many :aircrafts

  has_many :forum_topic_comments

  validates :name, presence: true, uniqueness: true, length: {minimum: 5}

  def has_admin?
    self.operators.each do |operator|
      return true if operator.roles.include?('admin')
    end
    false
  end

end
