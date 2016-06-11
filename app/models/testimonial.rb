class Testimonial < ActiveRecord::Base

  validate :name, presence: true
  validate :text, presence: true

end
