class City < ActiveRecord::Base
  #####VALIDATIONS###
  validates :name, presence: true
  validates :state, presence: true
  ###################
end
