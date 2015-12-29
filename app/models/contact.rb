class Contact < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :payment_transactions

  #validations
  validates_presence_of :first_name, :last_name, :email, :phone
  validates :email, uniqueness: true
  ############

end
