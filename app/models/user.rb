class User < ActiveRecord::Base

  include VersionTracker

  has_paper_trail

  has_many :trips

  has_many :testimonials

  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  ###############Validations#####
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, length: {is: 10}, numericality: true

  has_attached_file :image, presence: false, styles: {small: '50x50!', size_250x250: '250x250!'}, default_url: 'http://d3tfanr7troppj.cloudfront.net/static_files/images/000/000/257/original/default_user_picture.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ , :if => :image_attached?

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

  def image_attached?
    self.image.present?
  end

end
