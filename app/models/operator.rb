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

  # def can_add_trip?
  #   %w{admin ceo coo editor}.include?(self.designation)
  # end
  #
  # def can_add_unavailability?
  #   can_add_trip?
  # end
  #
  # def can_add_aircraft?
  #   %w{admin ceo coo editor}.include?(self.designation)
  # end
  #
  # def can_add_forum_topic?
  #   %w{admin ceo coo editor}.include?(self.designation)
  # end
  #
  # def can_add_forum_topic_comment?
  #   %w{admin ceo coo editor}.include?(self.designation)
  # end
  #
  # def can_add_new_operator?
  #   %w{admin ceo manager}.include?(self.designation)
  # end


  def can_add_trip?
    %w{admin ceo coo editor}.include?(self.designation)
  end

  def can_delete_trip?
    can_add_trip?
  end

  def can_add_unavailability?
    can_add_trip?
  end

  def can_delete_unavailability?
    can_add_trip?
  end

  def can_add_aircraft?
    %w{admin ceo}.include?(self.designation)
  end

  def can_edit_aircraft?
    can_add_aircraft?
  end

  def can_add_forum_topic?
    %w{admin ceo coo editor}.include?(self.designation)
  end

  def can_add_forum_topic_comment?
    %w{admin ceo coo editor}.include?(self.designation)
  end

  def can_add_new_operator?
    %w{admin manager}.include?(self.designation)
  end

end