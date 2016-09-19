class Admin::CustomersController < Admin::BaseController

  before_filter :authenticate_admin

  def index
    @customers = User.where("type is null").paginate(page: params[:page], per_page: 25)
  end

end