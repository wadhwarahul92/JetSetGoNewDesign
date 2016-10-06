class Admin::EnquiriesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_enquiry, only: [:show]

  def index
    @enquiries = Trip.where(status: Trip::STATUS_ENQUIRY).order(id: :desc).all.paginate(page: params[:page], per_page: 50)
  end

  def show

  end

  private

  def set_enquiry
    @enquiry = Trip.where(status: Trip::STATUS_ENQUIRY).find params[:id]
  end

end