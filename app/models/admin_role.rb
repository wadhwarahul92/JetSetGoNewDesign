class AdminRole < ActiveRecord::Base

  has_many :admin_roleships

  #validations
  validates :name, presence: true
  ############

end
