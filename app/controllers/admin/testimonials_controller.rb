class Admin::TestimonialsController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @testimonials = Testimonial.all
  end

end