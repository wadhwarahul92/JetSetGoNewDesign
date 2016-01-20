class JetstealSubscription < ActiveRecord::Base

  validates :email, presence: true

end