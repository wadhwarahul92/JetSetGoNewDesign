class Admin::ServiceEnquiriesController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @service_enquiries = YatraEnquiry.all.order(created_at: :desc).paginate(page: params[:page], per_page: 50)
  end

end