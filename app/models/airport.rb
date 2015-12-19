class Airport < ActiveRecord::Base

  belongs_to :city

  #####VALIDATIONS
  validates :name, presence: true, uniqueness: { scope: :city_id }
  validates :city, presence: true
  ################

end
