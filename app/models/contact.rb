class Contact < ActiveRecord::Base

  has_many :payment_transactions

  #validations
  validates_presence_of :first_name, :last_name, :email, :phone
  validates :email, uniqueness: true
  ############

end
