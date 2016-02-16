class JetstealSubscription < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  validates :email, presence: true, format: { with: /\A.+@.+\z/ }, uniqueness: true

  validates :name, presence: true

  validates :phone, presence: true, numericality: true

end