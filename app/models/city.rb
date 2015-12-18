class City < ActiveRecord::Base
  #####VALIDATIONS###
  validates :name, presence: true, uniqueness: { scope: :state }
  validates :state, presence: true
  ###################
end
