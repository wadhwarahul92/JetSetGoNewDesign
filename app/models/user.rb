class User < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :trips

  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  ###############Validations#####
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, length: {is: 10}, numericality: true
  ###############################

  def admin?
    self.type == 'Admin'
  end

  def operator?
    self.type == 'Operator'
  end

  def full_name
    "#{first_name.capitalize} #{last_name.try(:capitalize)}"
  end

end
