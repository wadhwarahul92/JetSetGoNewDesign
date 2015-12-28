class Contact < ActiveRecord::Base

  #validations
  validates_presence_of :first_name, :last_name, :email, :phone
  validates :email, uniqueness: true
  ############

end
