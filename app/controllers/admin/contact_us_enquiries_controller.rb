class Admin::ContactUsEnquiriesController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @contact_us_enquiries = ContactDetail.all.order(id: :desc).paginate(page: params[:page], per_page: 25)
  end

end