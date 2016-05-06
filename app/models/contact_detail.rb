class ContactDetail < ActiveRecord::Base

  validates_presence_of :name, :message, :email, :phone

end
