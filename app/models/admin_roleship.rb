class AdminRoleship < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  belongs_to :admin, class_name: 'Admin', foreign_key: :admin_id

  belongs_to :admin_role

  #validations
  validates :admin, presence: true
  validates :admin_role, presence: true
  ############

end
