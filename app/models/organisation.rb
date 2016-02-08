class Organisation < ActiveRecord::Base

  has_many :operators

  validates :name, presence: true, uniqueness: true

  def has_admin?
    self.operators.each do |operator|
      return true if operator.roles.include?('admin')
    end
    false
  end

end
