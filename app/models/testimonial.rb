class Testimonial < ActiveRecord::Base

  belongs_to :user

  validates :name, presence: true
  validates :text, presence: true

end
