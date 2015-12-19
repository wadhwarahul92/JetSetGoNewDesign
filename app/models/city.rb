class City < ActiveRecord::Base

  has_many :airports

  #####VALIDATIONS###
  validates :name, presence: true, uniqueness: { scope: :state }
  validates :state, presence: true
  ###################
end
