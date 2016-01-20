class JetstealSubscription < ActiveRecord::Base

  validates :email, presence: true, format: { with: /\A.+@.+\z/ }, uniqueness: true

  validates :name, presence: true

  validates :phone, presence: true, numericality: true

end