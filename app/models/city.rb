class City < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :airports

  has_attached_file :image, styles: {small: '50x50!'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  #####VALIDATIONS###
  validates :name, presence: true, uniqueness: { scope: :state }
  validates :state, presence: true
  validates :image, presence: true
  ###################
end
