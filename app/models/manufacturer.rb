class Manufacturer < ActiveRecord::Base

  validates :name, presence: true

end
