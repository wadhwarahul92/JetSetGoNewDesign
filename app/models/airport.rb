class Airport < ActiveRecord::Base

  belongs_to :city

  has_many :deaparting_jetsteals, class_name: 'Jetsteal', foreign_key: :departure_airport_id

  has_many :arriving_jetsteals, class_name: 'Jetsteal', foreign_key: :arrival_airport_id

  #####VALIDATIONS
  validates :name, presence: true, uniqueness: { scope: :city_id }
  validates :city, presence: true
  ################

end
