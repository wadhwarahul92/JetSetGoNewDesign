class Organisation < ActiveRecord::Base

  has_many :operators

  has_many :aircrafts

  validates :name, presence: true, uniqueness: true, length: {minimum: 5}

  def has_admin?
    self.operators.each do |operator|
      return true if operator.roles.include?('admin')
    end
    false
  end

end
